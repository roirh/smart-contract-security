// SPDX-License-Identifier: GPL-3.0

import "../utils/owned.sol";

pragma solidity >=0.7.0 <0.9.0;

contract AuctionNoWithdraw is Owned{

    address public highestBidder;
    uint public highestBid; //If 0, owner claimed the price

    uint public timestampAuctionCloses;

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

        //Return previous bid
        uint amount = highestBid;
        highestBid = 0; //set to 0 to avoid doble spending by reentrancy
        (bool success,) = highestBidder.call{value: amount}("");
        require(success, "Error sending back funds");
        
        //Store new bid
        highestBid = msg.value;
        highestBidder = msg.sender;
    }


    //If auction ended, allow owner to claim highest bid
    function claimHighestBid() public onlyOwner{
        require(timestampAuctionCloses > block.timestamp, "Auction not closed yet");
        require(highestBid > 0, "Already got funds");

        //Allow owner to withdraw the highest bid
        uint amount = highestBid;
        highestBid = 0;

        (bool success,) = owner.call{value: amount}("");
        require(success, "Error sending funds");
    }

}