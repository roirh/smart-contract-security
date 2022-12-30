// SPDX-License-Identifier: GPL-3.0

import "../utils/owned.sol";

pragma solidity >=0.7.0 <0.9.0;

//SAFE CONTRACT
//IMPLEMENTS PATTERN CHECK, EFFECTS, INTERACT to avoid reentrancy
//IMPLEMENTS PATTERN WITHDRAW to avoid reentrancy and state lock of contract
contract AuctionWithdraw is Owned{

    address public highestBidder;
    uint public highestBid; //If 0, owner claimed the price

    uint public timestampAuctionCloses;

    //withdraw allowances
    mapping(address => uint) public balances;
    

    constructor(uint _timestampAuctionCloses) payable{
        require( _timestampAuctionCloses > block.timestamp , "Auction should finish in the future");
        
        timestampAuctionCloses = _timestampAuctionCloses;

        //initial price set by msg.value
        highestBidder = msg.sender;
        highestBid = msg.value;
    }


    //Place new bid
    //value sent should be higher by at least 0.5eth than previous bid
    //previous bidder gets bid back
    function placeBid() public payable{
        require(timestampAuctionCloses < block.timestamp, "Auction closed");
        require(msg.value > highestBid + 0.5 ether, "bid should at least 0.5eth higher than previous");

        //Allow previous bidder to withdraw his last bid
        balances[highestBidder] += highestBid;

        //Store new bid
        highestBid = msg.value;
        highestBidder = msg.sender;
    }


    //If auction ended, allow owner to claim highest bid
    function claimHighestBid() public onlyOwner{
        require(timestampAuctionCloses > block.timestamp, "Auction not closed yet");
        require(highestBid > 0, "Already got funds");

        //Allow owner to withdraw the highest bid
        balances[owner] += highestBid;
        highestBid = 0;
    }

    //IMPLEMENTS PATTERN CHECK, EFFECTS, INTERACT
    function withdrawBids() public{
        //1: checks
        require( balances[msg.sender] > 0 , "Sender has no balance left to withdraw");

        //2: effects
        uint amount = balances[msg.sender];
        balances[msg.sender] = 0;
        
        //3: interactions
        (bool success,) = msg.sender.call{value: amount}("");
        require(success, "Error sending funds");
    }

}