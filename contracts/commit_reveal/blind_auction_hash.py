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

# Desc: Script to calculate keccak hash for BlindAuction contract


from eth_hash.auto import keccak
import binascii

print("Script to calculate keccak hash for BlindAuction contract\n")

#ASK for address, salt and value
address = input("\nInsert wallet address (0x1234567890ABC...):\n[ADDRESS]-> ")
salt = int(input("\nInsert numeric salt value (should fit in uint256):\n[SALT]-> "))
value = int(input("\nInsert numeric value to send (should fit in uint256):\n[VALUE]-> "))

if len(address) != 42:
    print("Address should have initial \"0x\", and include all 20bytes")
    exit()

#convert values to bytes
b_address = bytes.fromhex(address[2:])
b_salt = salt.to_bytes(32, byteorder = "big")
b_value = value.to_bytes(32, byteorder = "big")

#calculate keccak
encoded = b_address + b_salt + b_value
hash = keccak(encoded)

#return hash
hash_tohex = binascii.hexlify(hash).decode("ascii")
print("\nCALCULATED KECCAK HASH:")
print(" 0x"+hash_tohex.upper())

