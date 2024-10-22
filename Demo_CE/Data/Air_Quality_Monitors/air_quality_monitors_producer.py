with open('../../server_address.txt', 'r') as file:
    pulsar_address = file.readline().strip()  # Read the first line and strip any extra whitespace

import pulsar
client = pulsar.Client(pulsar_address)

import csv
import time
# Producer for the Air Quality Monitors topic
producer = client.create_producer('persistent://Smart_Home/Environmental_Monitoring/Air_Quality_Monitor')

# Open the CSV file
with open('air_quality_monitors.csv', 'r') as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        # Extract all values from the row and join them into a comma-separated string
        row_values = ','.join(row.values())
        # Send each row as a message
        producer.send(row_values.encode('utf-8'))
        print("Sent",row_values,"to Air_Quality_Monitor")
        
        time.sleep(1)  # Wait for 1 second between messages

client.close()
