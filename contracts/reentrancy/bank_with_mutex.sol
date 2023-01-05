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