# Autor: roirh
# 2022
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

