// SPDX-License-Identifier: GPL-3.0

import "../utils/owned.sol";

pragma solidity >=0.7.0 <0.9.0;

uint8 constant AUCTION_FINISHED = 0;
uint8 constant AUCTION_COMMIT = 1;
uint8 constant AUCTION_REVEAL = 2;


contract BlindAution is Owned{

    struct Participant {
        bytes32 commitment; //keccak256("address"+"(uint256)seed"+"(uint256)bid_value")
        uint256 commitValue; //Value commited

        bool revealed;
        uint256 bidValue;
    }


    uint8 auctionState;
    mapping(address => Participant) users;

    uint highestBid;
    address highestBidder;
    bool priceClaimed;

    uint valueUncheckedBids;

    uint blockNumberFinish;
    uint blockNumberReveal;

    constructor( uint256 _blockNumberReveal , uint256 _blockNumberFinish){
        auctionState = AUCTION_COMMIT;

        highestBid = 0;
        highestBidder = address(0);
        priceClaimed = false;

        valueUncheckedBids = 0;

        blockNumberFinish = _blockNumberFinish;
        blockNumberReveal = _blockNumberReveal;

    }


    //commitment == keccak256("address"+"(uint256)seed"+"(uint256)bid_value")
    //you should send more eth than bid_value for the bid to be valid
    //if you make an invalid bid, you'll lose it
    function sendBidCommit(bytes32 _commitment) external payable{
        checkUpdateAuctionState(AUCTION_COMMIT);
        require(msg.value > 0);

        users[msg.sender] = Participant(_commitment, msg.value, false, 0);

        //owner can withdraw this commitment if user doesnt reveal correctly
        valueUncheckedBids += msg.value;
    }

    //reveal bid
    //required for the bid to be valid
    function sendBidReveal(uint _seed, uint _bidValue) external{
        checkUpdateAuctionState(AUCTION_REVEAL);

        bytes32 _commitment = keccak256(abi.encodePacked(msg.sender , _seed, _bidValue));

        Participant storage p = users[msg.sender];
        require(p.commitment == _commitment, "Incorrect commitment");
        require(_bidValue > p.commitValue, "Not enought commitment value");

        p.revealed = true;
        p.bidValue = _bidValue;

        //user can withdraw his commitment if he is not the highest bidder
        valueUncheckedBids -= p.commitValue;
        checkUpdateHighestBidder(_bidValue);
    }

    function getRefund() external{
        //CHECK
        checkUpdateAuctionState(AUCTION_FINISHED);
        Participant storage p = users[msg.sender];
        require(p.revealed); //user didn't reveal in time

        //EFFECTS
        uint val = p.commitValue;
        if(msg.sender == highestBidder){ //winner can only withdraw excess of commit value
            val -= p.bidValue;  
        }
        //erase variables to get gas back
        p.commitment = 0;
        p.commitValue = 0;
        p.revealed = false;
        p.bidValue = 0;

        //INTERACT
        (bool success, ) = msg.sender.call{value: val}("");
        require(success);
    }

    
    function claimPrice() external{
        checkUpdateHighestBidder(AUCTION_FINISHED);
        require(msg.sender == highestBidder);
        require(priceClaimed == false);

        priceClaimed = true;
        //get some imaginary price
    }

    function withdrawWinnerBid() external onlyOwner(){
        require(highestBid > 0 );

        uint val = highestBid;
        highestBid =0;

        (bool success, ) = owner.call{value: val}("");
        require(success);
    }

    function withdrawUncheckedBids() external onlyOwner() {
        checkUpdateHighestBidder(AUCTION_FINISHED);
        uint256 val = valueUncheckedBids;
        valueUncheckedBids = 0;

        (bool success, ) = owner.call{value: val}("");
        require(success);
    }

    function checkUpdateHighestBidder(uint _bidValue) internal{
        if(_bidValue > highestBid){
            highestBid = _bidValue;
            highestBidder = msg.sender;
        }
    }

    function checkUpdateAuctionState(uint stateRequired) internal{
        updateAuctionState();
        require(auctionState == stateRequired);
    }

    function updateAuctionState() internal{
        if(auctionState == AUCTION_COMMIT){
            if(block.number >= blockNumberReveal) auctionState = AUCTION_REVEAL;
        }
        if(auctionState == AUCTION_REVEAL){
            if(block.number >= blockNumberFinish) auctionState = AUCTION_FINISHED;
        }
        //if auctionState == FINISHED no more checks to do
    }




}