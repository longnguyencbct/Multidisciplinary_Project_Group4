import importlib.util
import sys
from pathlib import Path
import pulsar
import csv
import time
import struct

# Define the relative path to the .so file based on the script's location
base_path = Path(__file__).resolve().parents[3]  # Adjust based on folder structure
sprintz_path = base_path / "Demo_CS/sprintz_encoder.cpython-312-x86_64-linux-gnu.so"

# Load the .so file dynamically
spec = importlib.util.spec_from_file_location("sprintz_encoder", sprintz_path)
sprintz_encoder = importlib.util.module_from_spec(spec)
sys.modules["sprintz_encoder"] = sprintz_encoder
spec.loader.exec_module(sprintz_encoder)

# Pulsar setup
with open('../pulsar_address.txt', 'r') as file:
    pulsar_address = file.readline().strip()

client = pulsar.Client(pulsar_address)
producer = client.create_producer('persistent://Smart_Home/Energy_Management/Energy_Monitoring_Device')

# Encode and send data
with open('energy_monitoring_device.csv', 'r') as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        row_values = ','.join(row.values())
        
        # Encode the row using the Sprintz encoder to get a single binary string
        encoded_data = sprintz_encoder.encode_string(row_values)

        # Convert the concatenated binary string to bytes
        binary_encoded_data = int(encoded_data, 2).to_bytes((len(encoded_data) + 7) // 8, byteorder='big')
        
        producer.send(binary_encoded_data)  # Send the encoded binary data
        
        print("Encoded row values (binary):", binary_encoded_data)
        print("Encoded row type:", type(binary_encoded_data))
        print("Length of encoded data in bytes:", len(binary_encoded_data))
        print()
        
        time.sleep(1)

client.close()
