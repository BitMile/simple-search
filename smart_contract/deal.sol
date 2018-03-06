/*
@ Filename : deal.sol
@ Author : 
@ Date Code : 

@ function : use store infomation of deal and answer
*/

pragma solidity ^0.4.0;

/* Interface of deal contract */
contract dealInterface {
    
    /* struct of a deal */
    struct Deal {
        uint256 dealId;
        bytes32 encPublicKey;
        bytes32 nonce;
        bytes32 docListEnc;
        uint256 price;
        uint256 expiredTime;
    }
    
    /* struct of a Answer */
    struct Answer {
        uint256 answerId;
        uint256 dealId;
        bool answer;
        uint256 ownerId;
        uint256 encDocId;
    }
    
    Deal [] public deals;
    Answer [] public answers;
    
    /* event create a deal and push event on block chain */
    event CreateDeal (
        uint256 _dealId,
        bytes32 _encPublicKey,
        bytes32 _nonce,
        bytes32 _docListEnc,
        uint256 _price,
        uint256 _expiredTime
    );
    
    /* event CreateAnswer and push event on block chain */
    event CreateAnswer (
        uint256 _answerId,
        uint256 _dealId, 
        bool _answer, 
        uint256 _ownerAddress, 
        uint256 _encDocId
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
        bytes32 _docListEnc,
        uint256 _price,
        uint256 _expiredTime
    ) public payable returns (bool);
    
    /* function get length of all deal */
    function lengthDeals () public constant returns (uint256);
    
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
        bytes32 nonce,
        bytes32 docListEnc,
        uint256 price,
        uint256 expiredTime
    );
    
    
    /* function create a Answer of user 
        @ param  _dealId id of deal
        @ param _answer answer of user
        @ param _ownerId id of owner
        @ param _encDocId id of document encrypted
        @ return 'true' if success or 'false' if not
    */
    function createAnswer (
        uint256 _dealId,
        bool _answer,
        uint256 _ownerId,
        uint256 _encDocId
    ) public payable returns (bool);
    
    /* function get information answer of a user 
        @ param _answerId id of answer get information
        @ return answerId id of answerId
                 dealId id of deal
                 answer answer of user
                 ownerId id of owner buy information
                 encDocId id of encrypt document 
    */
    function getAnswer (uint256 _answerId) 
    public constant returns (
        uint256 answerId,
        uint256 dealId,
        bool answer, 
        uint256 ownerId, 
        uint256 encDocId
    );
    
    /* function get leng of all answers */
    function lengthAnswer () public constant returns (uint256);
    
}

/* contract deal */
contract deal is dealInterface {
    
    /* function create a deal */
    function createDeal (
        bytes32 _encPublicKey,
        bytes32 _nonce,
        bytes32 _docListEnc,
        uint256 _price,
        uint256 _expiredTime
    ) public payable returns (bool) {
        /* check */
        require (_expiredTime > now);
        
        Deal memory _deal;
        uint256 _dealId = deals.length;
        
        _deal.dealId = _dealId;
        _deal.encPublicKey = _encPublicKey;
        _deal.nonce = _nonce;
        _deal.docListEnc = _docListEnc;
        _deal.price = _price;
        _deal.expiredTime = _expiredTime;
        
        deals.push(_deal);
        CreateDeal (
            _dealId,
            _encPublicKey,
            _nonce,
            _docListEnc,
            _price,
            _expiredTime
        );
        /* success return true */
        return true;
    }
    
    /* function get length of all deal */
    function lengthDeals () public constant returns (uint256) {
        return deals.length;
    }
    
    /* function get information of a deal */
    function getDeal (uint256 _dealId) public constant returns (
        uint256 dealId,
        bytes32 encPublicKey,
        bytes32 nonce,
        bytes32 docListEnc,
        uint256 price,
        uint256 expiredTime
    ) {
        /* check */
        require (_dealId < deals.length);
        
        return (
            deals[_dealId].dealId,
            deals[_dealId].encPublicKey,
            deals[_dealId].nonce,
            deals[_dealId].docListEnc,
            deals[_dealId].price,
            deals[_dealId].expiredTime
        );
    }
    
    /* function create a Answer of user */
    function createAnswer (
        uint256 _dealId,
        bool _answer,
        uint256 _ownerId,
        uint256 _encDocId
    ) public payable returns (bool) {
        /* check if it's id valid deal */
        require (_dealId < deals.length);
        require (deals[_dealId].expiredTime > now);
        
        Answer memory answer_;
        uint256 _answerId = answers.length;
        
        answer_.dealId = _dealId;
        answer_.answer = _answer;
        answer_.ownerId = _ownerId;
        answer_.encDocId = _encDocId;
        
        CreateAnswer(
            _answerId, 
            _dealId,
            _answer,
            _ownerId,
            _encDocId
        );
        answers.push(answer_);
        return true;
    }
    
    /* function get answer of a user */
    function getAnswer (uint256 _answerId) 
    public constant returns (
        uint256 answerId,
        uint256 dealId,
        bool answer, 
        uint256 ownerId, 
        uint256 encDocId
    ) {
        /* check */
        require (_answerId < answers.length);
        
        return (
            answers[_answerId].answerId,
            answers[_answerId].dealId,
            answers[_answerId].answer,
            answers[_answerId].ownerId,
            answers[_answerId].encDocId
        );
    }
    
    /* function get leng of all answers */
    function lengthAnswer () public constant returns (uint256) {
        return answers.length;
    }
    
}



