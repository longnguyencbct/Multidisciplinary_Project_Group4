import importlib.util
import sys
from pathlib import Path
import pulsar
import csv
import time

# Define the relative path to the .so file based on the script's location
base_path = Path(__file__).resolve().parents[3]  # Adjust based on folder structure
sprintz_path = base_path / "Demo_CS/sprintz_encoder.cpython-312-x86_64-linux-gnu.so"

# Load the .so file dynamically
spec = importlib.util.spec_from_file_location("sprintz_encoder", sprintz_path)
sprintz_encoder = importlib.util.module_from_spec(spec)
sys.modules["sprintz_encoder"] = sprintz_encoder
spec.loader.exec_module(sprintz_encoder)

# Pulsar setup
with open('../../server_address.txt', 'r') as file:
    pulsar_address = file.readline().strip()

client = pulsar.Client(pulsar_address)
# producer = client.create_producer('persistent://Smart_Home/Environmental_Monitoring/Air_Quality_Monitor')

# Encode and send data
with open('air_quality_monitors.csv', 'r') as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        row_values = ','.join(row.values())
        encoded_data = sprintz_encoder.encode_string(row_values)
        # producer.send(row_values.encode('utf-8'))  # Change if needed for encoded data
        print("Encoded row values:", encoded_data)
        print("Encoded row type:", type(encoded_data))
        print("Component type:",type(encoded_data[0]))
        print()

        time.sleep(1)

client.close()
