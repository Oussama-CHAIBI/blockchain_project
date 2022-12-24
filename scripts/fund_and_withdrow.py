from brownie import fundiMe
from scripts.help_scripts import get_account


def fundi():
    fundi_me = fundiMe[-1]
    account = get_account()
    entrance_fee = fundi_me.getEntranceFee() + 50
    print(entrance_fee)
    print(f"the current fee is {entrance_fee}")
    print("fundiing ...")
    fundi_me.fundi({"from": account, "value": entrance_fee})


def withdr():
    fundi_me = fundiMe[-1]
    account = get_account()
    fundi_me.withdr({"froms": account})


def mainn():
    fundi()
    withdr()
