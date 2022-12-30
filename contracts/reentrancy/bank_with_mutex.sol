// SPDX-License-Identifier: GPL-3.0

import "../utils/openzeppelin_reentrancy_guard.sol";


pragma solidity >=0.7.0 <0.9.0;

//EXAMPLE OF SIMPLE BANK CONTRACT SAFE TO REENTRANCY
//USES MUTEX defined IN ReentrancyGuard CONTRACT TO 
//AVOID REENTRANCY
contract SafeBankContractMutex is ReentrancyGuard{

    mapping(address => uint) public balances;

    //Deposit temporally funds to contract
    function deposit() public payable{
        require( msg.value > 0 );
        balances[msg.sender] += msg.value;
    }

    //Request back funds
    //Safe because it implements mutex in nonReentrant modifier
    //Cant call request again until it finishes
    function request(uint _value) public nonReentrant(){
        //Check enough balance
        require(balances[msg.sender] >= _value);

        //Send funds:
        (bool success,) = msg.sender.call{value: _value}("");
        require(success);

        //update balance
        balances[msg.sender] -= _value;
    }

}