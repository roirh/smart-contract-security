// SPDX-License-Identifier: GPL-3.0

import "./SendEther.sol";

pragma solidity >=0.7.0 <0.9.0;

contract TestCalls{

    SendEther s;
    address owner;

    constructor( SendEther _s) payable{
        owner = msg.sender;
        s = _s;
    }

    /**
     */
    function testSend( uint _value) public{
        s.sendViaSend{value: _value}( owner);
    }

    function testSend2(uint _value) public returns(bool) {
        (bool sucess,) = address(s).call{value: _value}(abi.encodeWithSignature("sendViaSend(address)",  owner));
        return sucess;
    }
}