#include "accountmanager.h"

AccountManager* AccountManager::getInstance() {
    static AccountManager* instance = NULL;

    if (instance == NULL) {
        instance = new AccountManager();
    }

    return instance;
}

AccountManager::AccountManager(QObject* parent): QObject(parent)
{
    username_ = "";
    password_ = "";

    secret_key_ = NULL;
    secret_key_len_ = 0;

    public_key_ = NULL;
    public_key_len_ = 0;

    socket_manager = new ZmqManager("localhost", "5555");
    proxy_socket_.connect("https://192.168.1.167:3000");

    proxy_socket_.socket()->on("newDeal", std::bind( &AccountManager::onNewDealReply, this, std::placeholders::_1, std::placeholders::_2));
}

void AccountManager::onNewDealReply(const std::string& mes, sio::message::ptr const& data){
    qDebug() << QString(mes.c_str()) << " " << QString(data->get_string().c_str());
}
AccountManager::~AccountManager() {
    delete socket_manager;
}

void AccountManager::setPassword(std::string password) {
    password_ = password;
}

void AccountManager::setUsername(std::string username) {
    username_ = username;
}

bool AccountManager::authenticate() {
    if (username_ == "" || password_ == "") {
        return false;
    }

    std::string file_path = (QDir::currentPath() + "/keystore/" + QString(username_.c_str()) + ".key").toStdString();
    std::string passphrase = password_;

    if (!KeyManager::getKey(file_path, passphrase,
                            &this->secret_key_, this->secret_key_len_,
                            &this->public_key_, this->public_key_len_)) {
        qDebug() << "failed to get key";
        return false;
    }

    qDebug() << "success get key";
    qDebug() << "sec: " << QString(Utils::convertToBase64(reinterpret_cast<unsigned char*>(this->secret_key_), this->secret_key_len_).c_str());
    qDebug() << "public key: " << QString(Utils::convertToBase64(reinterpret_cast<unsigned char*> (this->public_key_), this->public_key_len_).c_str());

    return true;
}

bool AccountManager::registerNewUser() {
    QString folderContainKeys = QDir::currentPath() + "/keystore";

    // create folder contain key if not exists before
    Utils::createFolder(folderContainKeys.toStdString());

    //if it's ok then create key file
    std::string file_path = (folderContainKeys + "/" + QString(username_.c_str()) + ".key").toStdString();
    std::string passphrase = password_;

    if (!KeyManager::createKey(file_path, passphrase)) {
        return false;
    }

    return true;
}
void AccountManager::clearCredential(){
    username_ = "";
    password_ = "";

    secret_key_ = NULL;
    secret_key_len_ = 0;

    public_key_ = NULL;
    public_key_len_ = 0;
}

void AccountManager::addKeyword(std::string keyword) {
    //TODO: preprocessing keyword

    if (keywords_.find(keyword) != keywords_.end()) {
        return;
    }
    keywords_.insert(keyword);
    Q_EMIT keywords_array_changed();
}

void AccountManager::removeKeyword(std::string keyword) {
    std::set<std::string>::iterator pos = keywords_.find(keyword);

    if (pos != keywords_.end()) {
        keywords_.erase(pos);
        Q_EMIT keywords_array_changed();
    }

}

void AccountManager::clearKeywords() {
    keywords_.clear();
    Q_EMIT keywords_array_changed();
}

std::set<std::string> AccountManager::getKeywords() {
    return keywords_;
}

std::vector<bitmile::db::Document> AccountManager::getSearchedDoc() {
    return searched_docs_;
}
void AccountManager::search () {
    searched_docs_.clear();
    std::vector<std::string> keywords (this->keywords_.begin(), this->keywords_.end());
    socket_manager->search(keywords, searched_docs_);

    if (searched_docs_.size() > 0) {

    }

    Q_EMIT search_done();
}


bool AccountManager::createDeal(std::string blockchain_addr, std::string blockchain_pass) {
    //qDebug() << "unlock account: " << blockchain_.UnlockAccount(blockchain_addr, blockchain_pass, 10);
    // emit binary
    char buf[] = "{\"mes\": \"test\"}";
    //proxy_socket_.socket()->emit("newDeal", std::make_shared<std::string>(buf,23));
    return true;
}

QString AccountManager::getSecretKey () const {
    return QString(Utils::convertToBase64(reinterpret_cast<unsigned char*>(this->secret_key_), this->secret_key_len_).c_str());
}


QString AccountManager::getPublicKey () const{
    QString(Utils::convertToBase64(reinterpret_cast<unsigned char*> (this->public_key_), this->public_key_len_).c_str());
}

QString AccountManager::getUsername() const {
    return QString::fromStdString(username_);
}

QString AccountManager::getPassword() const {
    return QString::fromStdString(password_);
}

