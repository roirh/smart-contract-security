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
# SendEther, ExpensiveWallet, CheapWallet
@pytest.fixture(autouse="true")
def isolate_functions(fn_isolation):
    pass

@given(
    amount=strategy('uint256', max_value=10**18),
    receiver=strategy('address')
)
def test_send_to_account(send_ether, amount,  receiver):
    sender = accounts[0]
    sender_balance = sender.balance()
    receiver_balance = receiver.balance()

    #check if enough balance in sender
    if amount <= sender_balance:
        send_ether.sendViaSend(receiver, {'from': sender, 'amount': amount})

        #check updated balance
        #important! assuming gas_price=0
        if sender != receiver:
            assert sender_balance - amount == sender.balance()
            assert receiver_balance + amount == receiver.balance()
        else:
            assert sender_balance == sender.balance() 

    else: #not enought balance, cant send tx 
        pass

@given(
    amount=strategy('uint256', max_value=1000**18),
    sender=strategy('address'),
    use_expensive_contract_wallet = strategy('bool')
)
def test_send_to_wallet(send_ether, amount, sender, use_expensive_contract_wallet, expensive_wallet, cheap_wallet):
    sender_balance = sender.balance()
    receiver =  expensive_wallet if use_expensive_contract_wallet else cheap_wallet
    receiver_balance = receiver.balance()

    #check if enough balance in sender
    if amount > sender_balance:
        return

    if use_expensive_contract_wallet:
        with reverts(): #expensive wallet reverts
            send_ether.sendViaSend(receiver.address, {'from': sender, 'amount': amount})

        assert sender_balance == sender.balance()

    else:
        send_ether.sendViaSend(receiver.address, {'from': sender, 'amount': amount})
        #check updated balance
        #important! assuming gas_price=0
        assert sender_balance - amount == sender.balance()
        assert receiver_balance + amount == receiver.balance()
    
