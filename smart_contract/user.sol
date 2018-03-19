/*
@@ Filename  : createWallet.js
@@ Author    : Phan Huy Phat
@@ Date Code : 

@ function create Wallet for User and
  return addressWallet, file keyObject, privateKey for User
*/

pragma solidity ^0.4.0;

/* contract userInterface */
contract userInterface {
    address owner;
    
    /* struct user */
    struct User {
        uint256 userId;
        address ownerId;
        string ownerPublicKey;
    }
    
    /* mapping bytes32 => struct User */
    mapping (address => User) users;
    address [] addressUsers;
    
    /* event AddUser on blockchain */
    event AddUser(uint256 _userId, address _ownerId, string _ownerPublicKey);
    
    /* function add a User 
        @ param _ownerPublicKey public key of user added
        @ return 'true' if success or 'false' if 'false'
    */
    function addUser (address _ownerId, string _ownerPublicKey) public payable returns (bool);
    
    /* function get information a User
        @ param _ownerPublicKey puclicKey of user want get information
        @ return ownerId and ownerPublicKey of user want get information
    */
    function getUser (address _ownerId) public constant returns (uint256, address, string);
    
    /* function get length array user */
    function lengthUser () public constant returns (uint256);
    
    /* function get address all users */
    function getAllUser () public constant returns (address[]);
}

/* contract user */
contract user is userInterface {
    
    /* function add User */
    function addUser (address _ownerId, string _ownerPublicKey) 
    public payable returns (bool) {
        User storage _user = users[_ownerId];
        uint256 _userId = addressUsers.length;
        
        _user.userId = _userId;
        _user.ownerId = _ownerId;
        _user.ownerPublicKey = _ownerPublicKey;
        
        addressUsers.push(_ownerId);
        emit AddUser(_userId, _ownerId, _ownerPublicKey);
        return true;
    }
    
    /* function get information a user */
    function getUser (address _ownerId) 
    public constant returns (
        uint256 userId,
        address ownerId,
        string ownerPublicKey
    ) {
        return (
            users[_ownerId].userId,
            users[_ownerId].ownerId,
            users[_ownerId].ownerPublicKey
        );
    }
    
    /* function get length users */
    function lengthUser () public constant returns (uint256) {
        return addressUsers.length;
    }
    
    /* function get address of all users */
    function getAllUser () public constant returns (address[]) {
        return addressUsers;
    }

}



