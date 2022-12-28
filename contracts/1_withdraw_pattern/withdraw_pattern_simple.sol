// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;


contract WithdrawPatternSimple{

    mapping(address => uint) public balances;

    // Add balance to account
    function donateTo(address _to) public payable{
        balances[_to] += msg.value;
    }

    //withdraw available funds
    function withdraw() public{
        uint userBalance = balances[msg.sender];
        balances[msg.sender] = 0;

        payable(msg.sender).transfer(userBalance);
    }


    function getBalanceOf(address addr) public view returns(uint){
        return balances[addr];
    }

}