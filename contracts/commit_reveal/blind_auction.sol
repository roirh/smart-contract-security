/* This file is part of https://github.com/roirh/smart-contract-security.
 * Copyright (c) 2023 Roi Rodriguez.
 * 
 * This program is free software: you can redistribute it and/or modify  
 * it under the terms of the GNU General Public License as published by  
 * the Free Software Foundation, version 3.
 *
 * This program is distributed in the hope that it will be useful, but 
 * WITHOUT ANY WARRANTY; without even the implied warranty of 
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU 
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License 
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

// SPDX-License-Identifier: GPL-3.0

import "../utils/owned.sol";

pragma solidity >=0.7.0 <0.9.0;

uint8 constant AUCTION_FINISHED = 0;
uint8 constant AUCTION_COMMIT = 1;
uint8 constant AUCTION_REVEAL = 2;

/// Error thrown if auction is in a different state than required to perform
/// a certain action
/// @param required auction state
/// @param actual auction state
error IncorrectAuctionState( uint8 required, uint8 actual);

/// Thrown if msg.value ==0
error InvalidPayment();

/// Thrown if bidValue is higher than payment made in commmit phase
/// @param commitmentValue payment made in commit fase
/// @param bidValue user bid value
error NotEnoughCommitmentValue(uint commitmentValue, uint bidValue);

/// Thrown if the commitment doesnt match seed and bidValue from user
error InvalidCommitment();

/// Thrown if user didn't reveal in time
error NotRevealed();

/// Thrown if user of admin already claimed their price
error AlreadyClaimed();


//Use this helper contract only in internal nodes or nodes you trust
//to avoid reveal your data
contract BlindAuctionHelper {
    function calculateHash(address _sender, uint256 _salt, uint256 _value) external pure returns(bytes32){
        return keccak256(abi.encodePacked(_sender,_salt,_value));
    }

    function checkHash(bytes32 _hash, address _sender, uint256 _salt, uint256 _value) external pure returns(bool){
        return _hash == keccak256(abi.encodePacked(_sender,_salt,_value));
    }

}

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
        if(msg.value == 0) revert InvalidPayment();

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
        if(p.commitment != _commitment) revert InvalidCommitment();
        if(_bidValue > p.commitValue) revert NotEnoughCommitmentValue(p.commitValue, _bidValue);

        p.revealed = true;
        p.bidValue = _bidValue;

        checkUpdateHighestBidder(_bidValue);
        
        //owner can no longer withdraw this commitment
        valueUncheckedBids -= p.commitValue;
    }

    function getRefund() external{
        //CHECK
        checkUpdateAuctionState(AUCTION_FINISHED);
        Participant storage p = users[msg.sender];
        if(!p.revealed) revert NotRevealed(); //user didn't reveal in time

        //EFFECTS
        uint val = p.commitValue;

        //winner can only withdraw excess of commit value
        if(msg.sender == highestBidder){ 
            val -= p.bidValue;  
        }

        //erase variables to get gas back
        //same user cant call again this function successfully
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
        if (priceClaimed) revert AlreadyClaimed();

        priceClaimed = true;
        //get some imaginary price
    }

    function withdrawWinnerBid() external onlyOwner(){
        if(highestBid == 0 ) revert AlreadyClaimed();

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

    function checkUpdateAuctionState(uint8 stateRequired) internal{
        updateAuctionState();
        if(auctionState != stateRequired){
            revert IncorrectAuctionState(stateRequired, auctionState);
        }
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