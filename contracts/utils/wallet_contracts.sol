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