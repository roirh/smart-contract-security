// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.7 <0.9.0;

abstract contract Owned {

    address payable owner;

    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }

    constructor() { owner = payable(msg.sender); }
    
}