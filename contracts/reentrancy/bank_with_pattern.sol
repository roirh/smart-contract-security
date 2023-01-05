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