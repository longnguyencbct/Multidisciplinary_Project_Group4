import csv
from typing import List

def read_csv(filename: str) -> List[List[float]]:
    data = []
    with open(filename, newline='') as csvfile:
        reader = csv.reader(csvfile)
        next(reader)  # Skip header
        for row in reader:
            rounded_row = [round(float(value), 3) for value in row[1:]]  # Skip timestamp and round values
            data.append(rounded_row)
    return data

def print_matrix(matrix: List[float]):
    for row in matrix:
        print(row)

def print_2d_matrix(matrix: List[List[float]]):
    for row in matrix:
        print(" ".join(map(str, row)))
