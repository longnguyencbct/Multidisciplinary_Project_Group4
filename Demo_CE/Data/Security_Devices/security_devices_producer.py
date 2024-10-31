with open('../../server_address.txt', 'r') as file:
    pulsar_address = file.readline().strip()  # Read the first line and strip any extra whitespace

import pulsar
client = pulsar.Client(pulsar_address)

import csv
import time

# Producer for the Security Devices topic
producer = client.create_producer('persistent://Smart_Home/Security_Surveilance/Security_Devices')

# Open the CSV file
with open('security_devices.csv', 'r') as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        # Send each row as a message every minute
        producer.send(str(row).encode('utf-8'))
        time.sleep(60)

client.close()
