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

from brownie import accounts, reverts #type: ignore
from brownie.test import given, strategy #type: ignore
from hypothesis import strategies #type: ignore
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
@pytest.fixture(autouse="true")
def isolate_functions(fn_isolation):
    pass


@given(
    amount=strategy('uint256', max_value=10**18),
    receiver=strategy('address')
)
def test_call_to_account(send_ether, amount,  receiver):
    sender = accounts[0]
    sender_balance = sender.balance()
    receiver_balance = receiver.balance()

    #check if enough balance in sender
    if amount <= sender_balance:
        send_ether.sendViaCall(receiver, {'from': sender, 'amount': amount})

        #check updated balance
        #important! assuming gas_price=0
        if sender != receiver:
            assert sender_balance - amount == sender.balance()
            assert receiver_balance + amount == receiver.balance()
        else:
            assert sender_balance == sender.balance() 

    else: #not enought balance, cant send tx 
        pass

##test send to contract
## send to wallet that uses more than 2300 gas should fail (expensive_wallet)
## send to wallet that uses less than 2300 gas should be ok (cheap_wallet)
@given(
    amount=strategy('uint256', max_value=1000**18),
    sender=strategy('address'),
    use_expensive_contract_wallet = strategy('bool')
)
def test_call_to_wallet(send_ether, amount, sender, use_expensive_contract_wallet, expensive_wallet, cheap_wallet):
    sender_balance = sender.balance()
    receiver =  expensive_wallet if use_expensive_contract_wallet else cheap_wallet
    receiver_balance = receiver.balance()

    #check if enough balance in sender
    if amount > sender_balance:
        return

    # Using call should success
    send_ether.sendViaCall(receiver.address, {'from': sender, 'amount': amount})
    #check updated balance
    #important! assuming gas_price=0
    assert sender_balance - amount == sender.balance()
    assert receiver_balance + amount == receiver.balance()

