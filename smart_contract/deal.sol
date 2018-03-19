/*
@ Filename : deal.sol
@ Author : 
@ Date Code : 

@ function : use store infomation of deal and answer
*/

pragma solidity ^0.4.20;

/* Interface of deal contract */
contract dealInterface {
    
    /* struct of a deal */
    struct Deal {
        uint256 dealId;
        bytes32 encPublicKey;
        address [] ownerIds;
        bytes32 [] encDocIds;
        bytes32 nonce;        
        uint256 price;
        uint256 expiredTime;
    }
    
    /* struct of a Answer */
    struct Answer {
        uint256 answerId;
        uint256 dealId;
        address [] ownerIds;
        bytes32 [] encDocIds;
        bool [] answerUsers;
    }
    
    /* struct Pay */
    struct Pay {
        uint256 payId;
        uint256 dealId;
        address[] fromAddresses;
        address[] toAddresses;
        uint256[] valueEthers;
    }
    
    /* struct ownerKey */
    struct OwnerKey {
        uint256 ownerKeyId;
        uint256 dealId;
        bytes32[] secEncKeys;
        bytes32[] encDocNonces;
        bytes32[] ownerNonces;
    }
    
    /* array struct */
    Deal [] public deals;
    Answer [] public answers;
    Pay [] pays;
    OwnerKey [] ownerKeys;
    
    
    /* event create a deal and push event on block chain */
    event CreateDeal (
        uint256 _dealId,
        bytes32 _encPublicKey,
        bytes32 _nonce,
        uint256 _price,
        uint256 _expiredTime,
        address [] _ownerIds,
        bytes32 [] _encDocIds
    );
    
    /* event update answer of user and push on block chain */
    event AnswerUser (
        uint256 _dealId,
        address _ownerId,
        bytes32 _encDocId,
        bool _answerUser
    );
    
    /* event payment status and push on blockchain */
    event Payment (
        uint256 _dealId,
        address _fromAddress,
        address _toAddress,
        uint256 _valueEther
    );
    

    /* function create a deal 
        @ param _encPublicKey encrypt Publick Key of owner user
        @ param _nonce used to encrypt 
        @ param _docListEnc List document encrypt
        @ param _price price customer pay for owner document
        @ param _expiredTime deathline of a deal user must Answer
        @ return 'true' if success or 'false' if not
    */
    function createDeal (
        bytes32 _encPublicKey,
        bytes32 _nonce,
        uint256 _price,
        uint256 _expiredTime,
        address [] ownerIds,
        bytes32 [] encDocIds
    ) public payable returns (bool);
    
    
    /* function get length of all deal */
    function lengthDeal () public constant returns (uint256);
    
    
    /* function get information of a deal 
        @ param _dealId id of a deal
        @ return dealId id of dealId
                 encPublicKey encrypt public Key
                 nonce nonce use encrypted
                 docListEnc list document encrypt
                 price price customer payable
                 expiredTime deathline of deal
    */
    function getDeal (uint256 _dealId) public constant returns (
        uint256 dealId,
        bytes32 encPublicKey,
        address [] ownerIds,
        bytes32 [] encDocIds,
        bytes32 nonce,
        uint256 price,
        uint256 expiredTime
    );
    
    
    /* function create a Answer of user 
        @ param  _dealId id of deal
        @ return 'true' if success or 'false' if not
    */
    function createAnswer (
        uint256 _dealId
    ) public payable returns (bool);
    
    
    /* function update answer of user 
        @ param _dealId id of dealId
        @ param _ownerId if of user answer
        @ param _encDocId id of document encrypted
        @ param _answerUser answer of user
        @ return 'true' if success or 'false' if not
    */
    function updateAnswer (
        uint256 _dealId,
        address _ownerId,
        bytes32 _encDocId,
        bool _answerUser
    ) public payable returns (bool); 
    
    
    /* function get information answer of a user 
        @ param _answerId id of answer get information
        @ return answerId id of answerId
                 dealId id of deal
                 ownerIds id of owner buy information
                 encDocIds id of encrypt document
                 answerUsers answer of user
    */
    function getAnswer (uint256 _answerId) 
    public constant returns (
        uint256 answerId,
        uint256 dealId,
        address [] ownerIds, 
        bytes32 [] encDocIds,
        bool[] answerUsers 
    );
    
    
    /* function get leng of all answers */
    function lengthAnswer () public constant returns (uint256);
    
    
    /* function create a Payment 
        @ param _dealId id of deal
        @ return 'true' if success or 'false' if not
    */
    function createPayment (
        uint256 _dealId
    ) public payable returns (bool);
    
    
    /* function update payment of a deal 
        @ param _dealId id of deal
        @ param _fromAddress address wallet of sender
        @ param _toAddress address wallet of reciver
        @ param _valueEther value 'ether' sended
        @ return 'true' if success or 'false' if not
    */
    function updatePayment (
        uint256 _dealId,
        address _fromAddress,
        address _toAddress,
        uint256 _valueEther
    ) public payable returns (bool);
    
    
    /* function get information of a Payment
        @ param _payId Id of a Payment
        @ return payId id of pay
                 fromAddresses addresseof customer send 'ether'
                 toAddresses address of user reciver 'ether'
                 valueEthers value 'ether' customer sended
    */
    function getPayment (uint256 _payId) public constant returns (
        uint256 payId,
        uint256 dealId,
        address[] fromAddress,
        address[] toAddress,
        uint256[] valueEthers
    );
    
    /* function get length of payments */
    function lengthPayment () public constant returns (uint256);
    
    /* function create OwnerKey 
        @ param _dealId id of a dealId
        @ return 'true' if success or 'false' if not
    */
    function createOwnerKey (
        uint256 _dealId
    ) public payable returns (bool);
    
    /* function update information owner Key of user into deal
        @ param _dealId id of deal
        @ param _secEncKey secret encrypt key of owner
        @ param _encDocNonce encrypt document nonce
        @ param _ownerNonce nonce of owner
        @ return 'true' if success or 'false' if not
    */
    function updateOwnerKey ( 
        uint256 _dealId,
        bytes32 _secEncKey,
        bytes32 _encDocNonce,
        bytes32 _ownerNonce
    ) public payable returns (bool);
    
    /* function get infomation of a ownerKey
        @ param _ownerKeyId id of ownerKey
        @ return ownerKeyId id of ownerKey
                 dealId id of deal
                 secEncKeys array encrypt secret Key
                 encDocNonces array encrypt document encDocNonce
                 ownerNonces array owner of nonce
    */
    function getOwnerKey (uint256 _ownerKeyId) public constant returns (
        uint256 ownerKeyId,
        uint256 dealId,
        bytes32[] secEncKeys,
        bytes32[] encDocNonces,
        bytes32[] ownerNonces
    );
    
    /* function get length of ownerKeys */
    function lengthOwnerKey () public constant returns (uint256);
    
}

/* contract deal */
contract deal is dealInterface {
    
    /* function create a deal */
    function createDeal (
        bytes32 _encPublicKey,
        bytes32 _nonce,
        uint256 _price,
        uint256 _expiredTime,
        address [] _ownerIds,
        bytes32 [] _encDocIds
    ) public payable returns (bool) {
        /* check */
        require (_expiredTime > now);
        require (_ownerIds.length == _encDocIds.length);
        
        uint256 _dealId = deals.length;
        Deal memory _deal;
        
        _deal.dealId = _dealId;
        _deal.encPublicKey = _encPublicKey;
        _deal.nonce = _nonce;
        _deal.price = _price;
        _deal.expiredTime = _expiredTime;
        
        deals.push(_deal);
        
        for (uint256 i = 0; i < _ownerIds.length; i++) {
            deals[_dealId].ownerIds.push(_ownerIds[i]);
            deals[_dealId].encDocIds.push(_encDocIds[i]);
        }
        
        emit CreateDeal (
            _dealId,
            _encPublicKey,
            _nonce,
            _price,
            _expiredTime,
            _ownerIds,
            _encDocIds
        );
        /* success return true */
        return true;
    }
    
    
    /* function get length of all deal */
    function lengthDeal () public constant returns (uint256) {
        return deals.length;
    }
    
    
    /* function get information of a deal */
    function getDeal (uint256 _dealId) public constant returns (
        uint256 dealId,
        bytes32 encPublicKey,
        address [] ownerIds,
        bytes32 [] encDocIds,
        bytes32 nonce,
        uint256 price,
        uint256 expiredTime
    ) {
        /* check */
        require (_dealId < deals.length);
        
        return (
            deals[_dealId].dealId,
            deals[_dealId].encPublicKey,
            deals[_dealId].ownerIds,
            deals[_dealId].encDocIds,
            deals[_dealId].nonce,
            deals[_dealId].price,
            deals[_dealId].expiredTime
        );
    }
    
    
    /* function create a Answer of user */
    function createAnswer (
        uint256 _dealId
    ) public payable returns (bool) {
        /* check if it's id valid deal */
        require (_dealId < deals.length);
        require (deals[_dealId].expiredTime > now);
        
        Answer memory answer_;
        
        answer_.answerId = _dealId;
        answer_.dealId = _dealId;
        
        answers.push(answer_);
        return true;
    }
    
    
    /* function update answer of user into deal */
    function updateAnswer (
        uint256 _dealId,
        address _ownerId,
        bytes32 _encDocId,
        bool _answerUser
    ) public payable returns (bool) {
        require (_dealId < deals.length);
        
        answers[_dealId].ownerIds.push(_ownerId);
        answers[_dealId].encDocIds.push(_encDocId);
        answers[_dealId].answerUsers.push(_answerUser);
        
        emit AnswerUser (
            _dealId,
            _ownerId,
            _encDocId,
            _answerUser
        );
    }
    
    
    /* function get answer of a user */
    function getAnswer (uint256 _answerId) 
    public constant returns (
        uint256 answerId,
        uint256 dealId,
        address [] ownerId, 
        bytes32 [] encDocId,
        bool[] answerUser
    ) {
        /* check */
        require (_answerId < answers.length);
        
        return (
            answers[_answerId].answerId,
            answers[_answerId].dealId,
            answers[_answerId].ownerIds,
            answers[_answerId].encDocIds,
            answers[_answerId].answerUsers
        );
    }
    
    
    /* function get leng of all answers */
    function lengthAnswer () public constant returns (uint256) {
        return answers.length;
    }
    
    
    /* function create a Payment */
    function createPayment (
        uint256 _dealId
    ) public payable returns (bool) {
        require (_dealId < deals.length);
        Pay memory _pay;
        
        _pay.payId = _dealId;
        _pay.dealId = _dealId;
        
        pays.push(_pay);
        return true;
    }
    
    
    /* function update Payment of deal */
    function updatePayment (
        uint256 _dealId,
        address _fromAddress,
        address _toAddress,
        uint256 _valueEther
    ) public payable returns (bool) {
        require (_dealId < deals.length);
        
        pays[_dealId].fromAddresses.push(_fromAddress);
        pays[_dealId].toAddresses.push(_toAddress);
        pays[_dealId].valueEthers.push(_valueEther);
        
        emit Payment (_dealId, _fromAddress, _toAddress, _valueEther);
        return true;
    }
    
    
    /* function get information of a Payment */
    function getPayment (uint256 _payId) public constant returns (
        uint256 payId,
        uint256 dealId,
        address[] fromAddresses,
        address[] toAddress,
        uint256[] valueEther
    ) {
        require (_payId < pays.length);
        return (
            pays[_payId].payId,
            pays[_payId].dealId,
            pays[_payId].fromAddresses,
            pays[_payId].toAddresses,
            pays[_payId].valueEthers
        );
    }
    
    
    /* function get length payments */
    function lengthPayment () public constant returns (uint256) {
        return pays.length;
    }

    
    /* function create a OwnerKey */
    function createOwnerKey (
        uint256 _dealId
    ) public payable returns (bool) {
        require (_dealId < deals.length);
        OwnerKey memory _ownerKey;
        
        _ownerKey.ownerKeyId = _dealId;
        _ownerKey.dealId = _dealId;

        ownerKeys.push(_ownerKey);
        return true;
    }
    
    
    /* function update OwnerKey into deal then customer pay ether for user */
    function updateOwnerKey (
        uint256 _dealId,
        bytes32 _secEncKey,
        bytes32 _encDocNonce,
        bytes32 _ownerNonce
    ) public payable returns (bool) {
        require (_dealId < deals.length);
        
        ownerKeys[_dealId].secEncKeys.push(_secEncKey);
        ownerKeys[_dealId].encDocNonces.push(_encDocNonce);
        ownerKeys[_dealId].ownerNonces.push(_ownerNonce);
        
        return true;
    }
    
    
    /* function get infomation of a ownerKey */
    function getOwnerKey (uint256 _ownerKeyId) public constant returns (
        uint256 ownerKeyId,
        uint256 dealId,
        bytes32[] secEncKeys,
        bytes32[] encDocNonces,
        bytes32[] ownerNonces
    ) {
        require (_ownerKeyId < ownerKeys.length);
        return (
            ownerKeys[_ownerKeyId].ownerKeyId,
            ownerKeys[_ownerKeyId].dealId,
            ownerKeys[_ownerKeyId].secEncKeys,
            ownerKeys[_ownerKeyId].encDocNonces,
            ownerKeys[_ownerKeyId].ownerNonces
        );
    }
    
    
    /* function get length of ownerKeys */
    function lengthOwnerKey () public constant returns (uint256) {
        return ownerKeys.length;
    }
    
}



