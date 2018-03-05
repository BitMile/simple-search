/*
@ Filename : user.sol
@ Author :
@ Date Code :

@ function : use store infomation of user
*/

pragma solidity ^0.4.0;


/* contract userInterface */
contract userInterface {
    //address owner;
    
    /* struct user */
    struct User {
        uint256 ownerId;
        address ownerAddress;
    }
    
    /* mapping address => struct User */
    mapping (address => User) users;
    address [] addressUsers;
    
    /* event AddUser on blockchain */
    event AddUser(uint256 _ownerId, address _ownerAddress);
    
    /* function add a User 
        @ param _ownerAddress address of user added
        @ return 'true' if success or 'false' if 'false'
    */
    function addUser () public payable returns (bool);
    
    /* function get information a User
        @ param _ownerAddress address of user want get information
        @ return ownerId and address of user want get information
    */
    function getUser (address _ownerAddress) public constant returns (uint256, address);
    
    /* function get length array user */
    function lengthUser () public constant returns (uint256);
    
    /* function get address all users */
    function getAllUser () public constant returns (address[]);
}

/* contract user */
contract user is userInterface {
    
    /* function add User */
    function addUser () 
    public payable returns (bool) {
        User storage _user = users[msg.sender];
        uint256 _ownerId = addressUsers.length;
        
        _user.ownerId = _ownerId;
        _user.ownerAddress = msg.sender;
        
        addressUsers.push(msg.sender);
        AddUser(_ownerId, msg.sender);
        return true;
    }
    
    /* function get information a user */
    function getUser (address _ownerAddress) 
    public constant returns (uint256, address) {
        return (
            users[_ownerAddress].ownerId,
            users[_ownerAddress].ownerAddress
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



