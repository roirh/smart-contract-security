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
 * 
 * Script intented to access storage of a contract, and examinate 
 * variables declared as private
 */

let urlRCP = "https://rpc.ankr.com/eth"
let rubixiAddr = "0xe82719202e5965cf5d9b6673b7503a3b92de20be"

const Web3 = require('web3');
const provider = new Web3.providers.HttpProvider(urlRCP);
const web3 = new Web3(provider);


async function getStorage(address, slots){
    for( let i=0; i<slots; i++ ){
        result = await web3.eth.getStorageAt(address,i);
        console.log("["+i+"]: "+result);
    }
}

getStorage(rubixiAddr,7)


/** how to access dinamic arrays:
let slotNum = 6; //Slot  corresponding to dinamic array
let slot =  web3.utils.soliditySha3(slotNum) //Get actual slot where storage of dynamic array starts

getStorageAt(address,slot) //Get firts data of array
getStorageAt(address,slot+1) //Get second data of array (if arraytype size is 256 bits)
//etc
*/