#ifndef _PEER_HPP_INCLUDED_
#define _PEER_HPP_INCLUDED_

#include <iostream>
#include <queue>
#include <thread>
#include <zmq.hpp>
#include <list>
#include <mutex>
#include <atomic>

#include "config.h"
#include "jsonhandle.hpp"
#include "numberhandle.hpp"

namespace bitmile {
class Peer {
	public:
		Peer();
		~Peer();

		bool run();
	private:
		bool setupWorker(zmq::context_t*);
		std::string getPublicIp();

		/*
		 * Because we use P2P comunication, so we need keep all node ip  in network
		 */
		void syncPeerListRequest (zmq::context_t*, bitmile::Json&);
		void syncPeerListResponse (zmq::socket_t*, bitmile::Json&);
		
		/* 
		 * For new instance join to network
		 * it need notify itself to boss instance
		 * network will keep ip to common list then notify to all node in network
		 */
		void notifyConnection (zmq::context_t*);
		void getPeerListResponse(zmq::socket_t*, bitmile::Json&);

		// broadcast message
		void broadcastMessage(bitmile::Json&);

		/*
		 * Generate and return blind number to client
		 */
		void clientBlindNumberRequest(zmq::socket_t*, bitmile::Json&);

		/*
		 * Generate and return blind number to client
		 */
		void peerBlindNumberRequest(zmq::socket_t*, bitmile::Json&);

		/*
		 * Generate blind message from random blind number
		 */
		void blindMessage(zmq::socket_t*,bitmile::Json&);

		/*
		 * Inverse blind message from Inverse pair with blind number
		 */
		void inverseMessage(zmq::socket_t*,bitmile::Json&);

		static void handleMessage(Peer*, worker_t*, zmq::context_t*);
		static std::string concatTcpIp(const char* ip, const char* port);
		static void ssend (zmq::socket_t*, std::string&);
	private:
		//std::queue<long long> thread_ids;
		std::queue<worker_t*> worker_list;

		// keep ips of peer node machine in network;
		// address value was string
		std::list<std::string> peer_ips;

		// keep mapper between client ip and blind number
		// pair {identify :  blind_number}
		std::map<std::string, std::string> blind_session;

		// keep flag check peer node was setup before run
		std::atomic<bool> setupFirst;
		
		std::string ip;
		std::mutex mutex;

		bitmile::NumberHandle numberHandle;
};
}

#endif