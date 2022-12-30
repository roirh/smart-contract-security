// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;


//EXAMPLE OF SIMPLE BANK CONTRACT SAFE TO REENTRANCY
//USES PATTERN CHECK, EFFECTS, INTERACT
contract SafeBankContractPattern {

    mapping(address => uint) public balances;

    //Deposit temporally funds to contract
    function deposit() public payable{
        require( msg.value > 0 );
        balances[msg.sender] += msg.value;
    }

    //Request back funds
    //SAFE TO REENTRANCY
    //USES PATTERN CHECK, EFFECTS, INTERACT
    function request(uint _value) public {
        //1-CHECK: Check enough balance
        require(balances[msg.sender] >= _value);

        //2-EFFECTS: update balance
        balances[msg.sender] -= _value;
        
        //3-INTERACT: Send funds
        //Note: no more state changes after this
        (bool success,) = msg.sender.call{value: _value}("");
        require(success);
    }

}