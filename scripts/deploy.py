from brownie import accounts, DutchAuction
from web3 import Web3

def deploy_contract_auction():
    account = accounts[0]
    DutchAuction.deploy({"from": account})

def main():
    deploy_contract_auction()