# Built-in
import numpy as np
from typing import List
from bitstring import BitArray

# Helper function
from helpers import read_csv


def bit_pack(errors: List[float]) -> List[BitArray]:
    packed = []
    for err in errors:
        negative = err < 0
        err = abs(err)
        err_bit = BitArray(float=err, length=32)
        if negative:
            err_bit.set(1, 0)  # Set the sign bit for negative
        packed.append(err_bit)
    return packed

def encode_block(data: List[float]) -> List[BitArray]:
    errors = [data[0]]
    prev_value = data[0]
    for value in data[1:]:
        error = value - prev_value
        errors.append(error)
        prev_value = value
    return bit_pack(errors)

def decode(packed_data: List[BitArray]) -> List[float]:
    decoded_data = []
    prev_value = 0
    for packed in packed_data:
        negative = packed[0]
        error = packed[1:].float  # Ignore the sign bit
        if negative:
            error = -error
        original_value = prev_value + error
        decoded_data.append(original_value / 1000)
        prev_value = original_value
    return decoded_data

def sprintz_compression(filename: str) -> None:
    csv_data = read_csv(filename)

    for i in range(len(csv_data[0])):  # Number of columns
        data = [row[i] * 1000 for row in csv_data]  # Scale data
        encoded = encode_block(data)
        decoded = decode(encoded)

        print(f"Decoded data for row {i + 1}:")
        print(decoded)
