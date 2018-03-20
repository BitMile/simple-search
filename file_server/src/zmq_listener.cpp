#include "zmq_listener.h"

#define READY "READY"

namespace bitmile {
  ZmqListener::ZmqListener() {
    //default contructor

    //init context
    context_ = new zmq::context_t(1);

    //init socket
    clients_socket_ = new zmq::socket_t (*context_, ZMQ_ROUTER);
    workers_socket_ = new zmq::socket_t (*context_, ZMQ_ROUTER);

    //TODO: change num workers here
    //init number of workers
    num_workers_ = 5;


    msg_handler_ = new MessageHandler();

    //start network connection
    Start();
  }

  void ZmqListener::Start() {
    pthread_create(&zmq_thread_, NULL, StartInitConnection, this);
  }

  void *ZmqListener::StartWorkerRoutine(void *arg) {
    //TODO: handle pointer casting properly, should not cast directly

    assert (arg != NULL);

    return ((ZmqListener*) arg)->WorkerRoutine(((ZmqListener*) arg)->context_);
  }

  void *ZmqListener::WorkerRoutine(void *arg) {
    assert (arg != NULL);

    //get context object from argument
    zmq::context_t *context = (zmq::context_t *) arg;

    zmq::socket_t socket (*context, ZMQ_REQ);

    socket.connect ("inproc://workers");

    s_send (socket, READY);

    while (1) {
      //receive three part message
      std::string client_id = s_recv (socket);

      {
        std::string empty = s_recv (socket);
        assert (empty.size() == 0);
      }

      //receive raw message from zmq socket
      zmq::message_t request;
      socket.recv(&request);

      msg::Message* mes;

      if (request.size() >= sizeof (msg::MessageType)) {

        //get message type first
        msg::MessageType type;
        memcpy (&type, (char*)request.data(), sizeof (msg::MessageType));

        //parse raw data into specific message format
        mes = mes_factory_.CreateMessage(type, (char*)request.data() + sizeof (msg::MessageType), request.size() - sizeof (msg::MessageType));

      }else {

        //error - can't parse message type
        mes = mes_factory_.CreateMessage(msg::MessageType::ERROR, NULL, 0);
      }

      //handle input message
      msg::Message* ret_mes = msg_handler_->Handle (mes);


      //send back processed message to router
      //wrap it with client id
      s_sendmore (socket, client_id);
      s_sendmore (socket, "");

      //make zmq message and send it back to client
      std::vector<char> ret_data;
      ret_mes->Serialize(ret_data);

      zmq::message_t reply (ret_data.size());
      memcpy ((void*) reply.data(), ret_data.data(), ret_data.size());

      //free up memory from intermediate message
      delete mes;
      delete ret_mes;

      socket.send(reply);
    }

    return NULL;
  }

  void *ZmqListener::StartInitConnection(void *arg) {
    assert (arg != NULL);

    return ((ZmqListener*) arg)->InitConnection(NULL);
  }

  void *ZmqListener::InitConnection(void *arg) {


    //TODO: change port to dynamic
    //start accepting connection from clients
    clients_socket_->bind ("tcp://*:5555");

    //init connection for worker threads
    workers_socket_->bind ("inproc://workers");

    //start workers threads
    for (int num_threads = 0; num_threads < num_workers_; num_threads++) {
      pthread_t worker;
      //create threads with worker function here
      pthread_create (&worker, NULL, StartWorkerRoutine, this);
    }

    //link current threads to workers threads
    ClientBalancingMsgBroker(*clients_socket_, *workers_socket_, num_workers_);

    return NULL;
  }

  void ZmqListener::ClientBalancingMsgBroker (zmq::socket_t& frontend, zmq::socket_t& backend, int worker_num) {

    zmq::pollitem_t items[] = {
      {(void*)backend, 0, ZMQ_POLLIN, 0},
      {(void*)frontend, 0, ZMQ_POLLIN, 0}
    };

    std::vector <std::string> worker_queue;
    std::map <std::string, std::string> client_to_worker;

    int worker_turn = 0;

    while (1) {
      if (worker_queue.size() < worker_num) {
        //first, we must make sure all worker are in place
        //before receiving any message from the client
        //by waiting for READY message from all worker
        zmq::poll(items, 1, -1);

      }else {
        zmq::poll(items, 2, -1);
      }

      if (items[0].revents & ZMQ_POLLIN) {
        /*handle worker activity
         * ----------------------------------
         *|worker_id|empty|Client|empty|reply|
         * ----------------------------------
         * or
         * ---------------------
         *|worker_id|empty|READY|
         * ---------------------
         */
        std::string worker_id = s_recv (backend);

        {
          std::string empty = s_recv (backend);
          assert (empty.size() == 0);
        }

        std::string client_id = s_recv (backend);

        if (client_id.compare (READY) != 0) {
          {
            std::string empty = s_recv (backend);
            assert (empty.size() == 0);
          }

          std::string reply = s_recv(backend);
          s_sendmore(frontend, client_id);
          s_sendmore(frontend, "");
          s_send(frontend, reply);
        }else {
          //if it's READY message then worker is ready to receive
          //client message
          worker_queue.push_back(worker_id);
        }
      }

      if (items[1].revents & ZMQ_POLLIN) {
        /*
         * get clients message
         * -----------------------
         *|client id|empty|request|
         * -----------------------
         */
        std::string client_id = s_recv (frontend);
        {
          std::string empty = s_recv (frontend);
          assert (empty.size() == 0);
        }

        std::string request = s_recv (frontend);

        //distribute work to workers
        std::string worker_id;


        if (client_to_worker.find (client_id) == client_to_worker.end())  {
          //if new client connect to server, add to worker such as
          //number of client per worker is equal
          worker_id = worker_queue[worker_turn];
          worker_turn = (worker_turn + 1) % worker_queue.size();
        }
        else {
          //if client already connected to server
          //route it to previous workers that it connected to.
          //This stimulate a fake stateful session
          worker_id = client_to_worker[client_id];
        }

        /*
         * wrap message with worker address
         * ---------------------------------------
         *|worker_id|empty|client_id|empty|request|
         * ---------------------------------------
         */
        s_sendmore (backend, worker_id);
        s_sendmore (backend, "");
        s_sendmore (backend, client_id);
        s_sendmore (backend, "");
        s_send (backend, request);
      }
    }

  }

}//namespace bitmile
