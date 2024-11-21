import importlib.util
import sys
from pathlib import Path
import pulsar
import csv
import time

# Define the relative path to the .so file based on the script's location
sprintz_path = Path(__file__).resolve().parents[1] / "shared" / "sprintz_encoder.cpython-310-x86_64-linux-gnu.so"

# Load the .so file dynamically
spec = importlib.util.spec_from_file_location("sprintz_encoder", sprintz_path)
sprintz_encoder = importlib.util.module_from_spec(spec)
sys.modules["sprintz_encoder"] = sprintz_encoder
spec.loader.exec_module(sprintz_encoder)

# Pulsar setup
with open('../pulsar_address.txt', 'r') as file:
    pulsar_address = file.readline().strip()

client = pulsar.Client(pulsar_address)
producer = client.create_producer('persistent://Smart_Home/Energy_Management/Appliance_Control_Device')

# Encode and send data
with open('appliance_control_device.csv', 'r') as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        row_values = ','.join(row.values())
        
        # Encode the row using the Sprintz encoder to get a single binary string
        encoded_data = sprintz_encoder.encode_string(row_values)

        # Ensure the binary string is padded to a multiple of 8 bits
        encoded_data = encoded_data.zfill((len(encoded_data) + 7) // 8 * 8)

        # Convert the concatenated binary string to bytes
        binary_encoded_data = int(encoded_data, 2).to_bytes((len(encoded_data) + 7) // 8, byteorder='big')
        print("---Appliance_Control_Device Producer sending message---")
        # Debug prints to verify conversion
        print("Raw row values:\n", row_values)
        print("Encoded data (binary string):\n", encoded_data)
        print("Converted to binary encoded data:\n", binary_encoded_data)
        
        producer.send(binary_encoded_data)  # Send the encoded binary data
        
        print("Number of bits in encoded data:\n", len(encoded_data))
        print()
        
        time.sleep(1)

client.close()