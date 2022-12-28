// SPDX-License-Identifier: GPL-3.0

import "./owned.sol";

pragma solidity >=0.8.7 <0.9.0;

abstract contract Destructible is Owned {

    function destroy() virtual public onlyOwner{
        selfdestruct(owner);
    }
}