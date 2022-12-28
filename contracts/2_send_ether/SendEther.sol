// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract SendEther{

    /**
     */
    function sendViaSend(address _to) public payable{
        (bool success) = payable(_to).send(msg.value);
        require(success, "Error using send");
    }

    function sendViaTransfer(address _to ) public payable{
        payable(_to).transfer(msg.value);
    }

    function sendViaCall(address _to, uint256 _gas) public payable{
        (bool success,) = _to.call{value: msg.value, gas: _gas}("");
        require(success, "Error using call");
    }



}