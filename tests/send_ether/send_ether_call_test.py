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
