// SPDX-License-Identifier: GPL-3.0

import "./owned.sol";
import "./destructible.sol";

pragma solidity >=0.8.0 <0.9.0;

contract ExpensiveWallet is Destructible{
    
    uint public num;

    //Perform write to spend more than 2300 gas
    fallback() external payable{
        num=block.number; 
    }
   
}

contract CheapWallet is Destructible{

    //Cheap fallback function (less than 2300 gas)
    fallback() external payable{
    }

}