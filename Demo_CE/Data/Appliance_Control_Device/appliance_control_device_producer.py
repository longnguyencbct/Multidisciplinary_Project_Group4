with open('../../server_address.txt', 'r') as file:
    pulsar_address = file.readline().strip()  # Read the first line and strip any extra whitespace

import pulsar
client = pulsar.Client(pulsar_address)

import csv
import time

# Producer for the Appliance Control Device topic
producer = client.create_producer('persistent://Smart_Home/Energy_Management/Appliance_Control_Device')

# Open the CSV file
with open('appliance_control_device.csv', 'r') as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        # Send each row as a message every minute
        producer.send(str(row).encode('utf-8'))
        time.sleep(60)

client.close()
