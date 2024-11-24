import importlib.util
import sys
from pathlib import Path
import pulsar

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
consumer = client.subscribe('persistent://Smart_Home/Energy_Management/Appliance_Control_Device', subscription_name='my-subscription')

while True:
    msg = consumer.receive()
    try:
        print("---Appliance_Control_Device Consumer received message---")
        # Get the binary data from the message
        binary_encoded_data = msg.data()
        
        # Convert the binary data to a binary string
        encoded_data = bin(int.from_bytes(binary_encoded_data, byteorder='big'))[2:]
        
        # Ensure the binary string is padded to a multiple of 8 bits
        encoded_data = encoded_data.zfill(len(binary_encoded_data) * 8)
        
        # Debug prints to verify conversion
        print("Received binary encoded data:\n", binary_encoded_data)
        print("Converted to binary string:\n", encoded_data)
        
        # Decode the binary string using the Sprintz decoder
        decoded_data = sprintz_encoder.decode_string(encoded_data)
        
        print("Number of bits in received encoded data:\n", len(encoded_data))
        print("Decoded data:\n", decoded_data)
        print()
        
        consumer.acknowledge(msg)
    except Exception as e:
        print("Failed to process message:", e)
        consumer.negative_acknowledge(msg)

client.close()