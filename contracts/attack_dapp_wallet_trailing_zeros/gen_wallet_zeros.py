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

 
import argparse
from eth_account import Account


##Setup parser
parser = argparse.ArgumentParser(
    prog= "gen_wallet_zeros",
    description= "Generate ETH wallet with trailing zeros in the public address")

parser.add_argument('-zeros','-z',
    metavar="4",
    type=int,
    default = 4,
    dest='zeros',
    help="number of trailing zeros that the generated address should contain"
    )

#Parse args
args = parser.parse_args()
zeros = args.zeros

string = '0'*zeros
expected_tries = 16**zeros

print("Number of zeros:",zeros)
print("Expected # of tries:", expected_tries)

tries = 0
done = False

while not done:
    account = Account.create()
    tries += 1
    #check if generated account has # trailing zeros 
    if account.address[-zeros:] == string:
        done = True
    
    #Show progress every 1000 tries
    if tries%1000 == 0:
        print("# of tries:",tries,"\texpected # of tries:",expected_tries)


print("Public addr:", account.address)
print("Private key:", account.key.hex())
