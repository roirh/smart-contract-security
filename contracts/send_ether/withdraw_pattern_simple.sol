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

pragma solidity >=0.7.0 <0.9.0;

contract WithdrawPatternSimple{

    mapping(address => uint) public balances;

    // Add balance to account
    function donateTo(address _to) public payable{
        balances[_to] += msg.value;
    }

    //withdraw available funds
    //USE CHECK EFECTS INTERACTION pattern
    function withdraw() public{
        //1: checks
        require(balances[msg.sender]>0,"No funds to withdraw");

        //2: effects - modify state of contract
        uint userBalance = balances[msg.sender];
        balances[msg.sender] = 0;

        //3: interaction - external calls, no effects after this
        (bool success,) = payable(msg.sender).call{value: userBalance}("");
        require(success);
    }


    function getBalanceOf(address addr) public view returns(uint){
        return balances[addr];
    }
}