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

contract SharedWallet{
    mapping (address => uint) balances;

    function deposit() public payable{
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint _wei) public payable{
        require(balances[msg.sender] >= _wei);

        //Sent ether back to user
        (bool status, ) = msg.sender.call{value: _wei}("");
        require(status);
        //payable(msg.sender).transfer(_wei);

        //Update user balance
        unchecked{ balances[msg.sender] -= _wei; }
    }

    function getBalance(address usuario) public view returns(uint) {
        return balances[usuario];
    }

    function getBalance() public view returns(uint){
        return balances[msg.sender];
    }

}