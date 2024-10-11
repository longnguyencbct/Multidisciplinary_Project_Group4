with open('../../server_address.txt', 'r') as file:
    pulsar_address = file.readline().strip()  # Read the first line and strip any extra whitespace

import pulsar
client = pulsar.Client(pulsar_address)

import csv
import time

# Producer for the Energy Monitoring Device topic
producer = client.create_producer('persistent://Smart_Home/Energy_Management/Energy_Monitoring_Device')

# Open the CSV file
with open('energy_monitoring_device.csv', 'r') as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        # Send each row as a message every minute
        producer.send(str(row).encode('utf-8'))
        time.sleep(60)  # Send one message every minute

client.close()
