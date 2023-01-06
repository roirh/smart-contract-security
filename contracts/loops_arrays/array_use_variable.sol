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


contract ArrayVariable {

uint[] dataArray;
uint lenght = 0; //controls lenght of array

function getData(uint _pos) public view returns(uint){
    require(_pos < lenght);

    return dataArray[_pos];
}

function getLength() public view returns(uint){
    return lenght;
}

function addData(uint data) public{
    dataArray.push(data);
    lenght +=1;
}

function eraseArray() public{
    lenght = 0;
}

//Not necessary now to avoid out of gas
function deleteElements(uint _n) public{
    require(_n < lenght);

    lenght -= _n;
}
}