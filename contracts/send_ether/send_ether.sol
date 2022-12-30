// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract SendEther{

    //send()
    //-Returns boolean with results
    //-gives 2300 gas
    //-safe to reentrancy
    //-can fail sending to contracts
    function sendViaSend(address _to) public payable{
        (bool success) = payable(_to).send(msg.value);
        require(success, "Error using send");
    }

    //transfer()
    //-reverts if fails
    //-gives 2300 gas
    //-safe to reentrancy
    //-can fail sending to contracts
    function sendViaTransfer(address _to ) public payable{
        payable(_to).transfer(msg.value);
    }

    //call{value: x}()
    //-Returns boolean with results
    //-forwards all gas by default (configurable)
    //-unsafe to reentrancy if used improperly
    //-allows sending to contracts that spends more than 2300 gas
    function sendViaCall(address _to, uint256 _gas) public payable{
        (bool success,) = _to.call{value: msg.value, gas: _gas}("");
        require(success, "Error using call");
    }



}