// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;


//EXAMPLE OF SIMPLE BANK CONTRACT UNSAFE TO REENTRANCY
//NOT SAFE TO REENTRANCY
//NO MUTEX IN USE
//UPDATES STATE AFTER MAKING EXTERNAL CALL
contract UnsafeBankContract {

    mapping(address => uint) public balances;

    //Deposit temporally funds to contract
    function deposit() public payable{
        require( msg.value > 0 );
        balances[msg.sender] += msg.value;
    }

    //Request back funds
    //NOT SAFE TO REENTRANCY
    //NO MUTEX IN USE
    //UPDATES STATE AFTER MAKING EXTERNAL CALL
    function request(uint _value) public {
        //Check enough balance
        require(balances[msg.sender] >= _value);

        //Send funds
        (bool success,) = msg.sender.call{value: _value}("");
        require(success);

        //update balance
        balances[msg.sender] -= _value;
    }

}