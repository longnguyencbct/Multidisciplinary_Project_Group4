with open('../../server_address.txt', 'r') as file:
    pulsar_address = file.readline().strip()  # Read the first line and strip any extra whitespace

import pulsar
client = pulsar.Client(pulsar_address)

import csv
import time

# Producer for the Surveillance Cameras topic
producer = client.create_producer('persistent://Smart_Home/Security_Surveilance/Surveilance_Cameras')

# Open the CSV file
with open('surveillance_cameras.csv', 'r') as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        # Send each row as a message every minute
        producer.send(str(row).encode('utf-8'))
        time.sleep(60)

client.close()
