# 
# This file is part of https://github.com/roirh/smart-contract-security.
# Copyright (c) 2023 Roi Rodriguez.
# 
# This program is free software: you can redistribute it and/or modify  
# it under the terms of the GNU General Public License as published by  
# the Free Software Foundation, version 3.
#
# This program is distributed in the hope that it will be useful, but 
# WITHOUT ANY WARRANTY; without even the implied warranty of 
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU 
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License 
# along with this program. If not, see <http://www.gnu.org/licenses/>.

import pytest # type: ignore

## DEPLOY CONTRACTS
# SendEther, ExpensiveWallet, CheapWallet
@pytest.fixture(scope="module")
def send_ether(SendEther, accounts):
    return accounts[0].deploy(SendEther)


@pytest.fixture(scope="module")
def expensive_wallet(ExpensiveWallet, accounts):
    return accounts[0].deploy(ExpensiveWallet)


@pytest.fixture(scope="module")
def cheap_wallet(CheapWallet, accounts):
    return accounts[0].deploy(CheapWallet)

## ISOLATE STATE OF EACH TEST
# SendEther, ExpensiveWallet, CheapWallet
@pytest.fixture(autouse="true")
def isolate_functions(fn_isolation):
    pass



def test_call_to_account(send_ether, accounts):
    balance = accounts[1].balance()
    gas = 0
    send_ether.sendViaCall(accounts[1], gas , {'from': accounts[0], 'amount': "10 ether"})
    
    assert balance + "10 ether" == accounts[1].balance()
