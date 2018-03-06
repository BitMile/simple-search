/*
@ Filename : user.sol
@ Author :
@ Date Code :

@ function : use store infomation of user
*/

pragma solidity ^0.4.0;

/* contract userInterface */
contract userInterface {
    address owner;
    
    /* struct user */
    struct User {
        uint256 ownerId;
        address ownerPublicKey;
    }
    
    /* mapping address => struct User */
    mapping (address => User) users;
    address [] addressUsers;
    
    /* event AddUser on blockchain */
    event AddUser(uint256 _ownerId, address _ownerPublicKey);
    
    /* function add a User 
        @ param _ownerPublicKey address of user added
        @ return 'true' if success or 'false' if 'false'
    */
    function addUser (address _ownerPublicKey) public payable returns (bool);
    
    /* function get information a User
        @ param _ownerPublicKey address of user want get information
        @ return ownerId and ownerPublicKey of user want get information
    */
    function getUser (address _ownerPublicKey) public constant returns (uint256, address);
    
    /* function get length array user */
    function lengthUser () public constant returns (uint256);
    
    /* function get address all users */
    function getAllUser () public constant returns (address[]);
}

/* contract user */
contract user is userInterface {
    
    /* function add User */
    function addUser (address _ownerPublicKey) 
    public payable returns (bool) {
        User storage _user = users[_ownerPublicKey];
        uint256 _ownerId = addressUsers.length;
        
        _user.ownerId = _ownerId;
        _user.ownerPublicKey = _ownerPublicKey;
        
        addressUsers.push(_ownerPublicKey);
        AddUser(_ownerId, _ownerPublicKey);
        return true;
    }
    
    /* function get information a user */
    function getUser (address _ownerPublicKey) 
    public constant returns (
        uint256 ownerId, 
        address ownerPublicKey
    ) {
        return (
            users[_ownerPublicKey].ownerId,
            users[_ownerPublicKey].ownerPublicKey
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


