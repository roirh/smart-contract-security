// SPDX-License-Identifier: GPL-3.0

import "../utils/owned.sol";

pragma solidity >=0.7.0 <0.9.0;

contract AuctionNoWithdraw is Owned{

    address public highestBidder;
    uint public highestBid; //If 0, auction finished

    uint public timestampAuctionCloses; //when auction finish

    constructor(uint _timestampAuctionCloses) payable{
        require( _timestampAuctionCloses > block.timestamp , "Auction should finish in the future");
        
        timestampAuctionCloses = _timestampAuctionCloses;

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
    function auctionEnded() public onlyOwner{
        require(timestampAuctionCloses > block.timestamp, "Auction not closed yet");
        require(highestBid > 0, "Already got funds");

        //Allow owner to withdraw the highest bid
        uint amount = highestBid;
        highestBid = 0;
        (bool success,) = owner.call{value: amount}("");
        require(success, "Error sending funds");
    }

    //Returns winner if auction closed
    function getWinner() public view returns(address){
        if(timestampAuctionCloses > block.timestamp){
            return highestBidder;
        }
        return address(bytes20(0));
    }


}