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
pragma solidity 0.8.17;


contract ArrayDeleteElements {
    uint[] public dataArray;

    function getLength() public view returns(uint){
        return dataArray.length;
    }

    function addData(uint data) public{
        dataArray.push(data);
    }

    function eraseArray() public{
        delete dataArray;
    }

    //Adds this function to be able to delete the array partially
    //In case eraseArray() cost too much gas
    //Deletes last _n elements
    function deleteElements(uint _n) public{
        require(_n < dataArray.length);

        for(; _n>0 ; _n--){
            dataArray.pop();
        }
    }
}