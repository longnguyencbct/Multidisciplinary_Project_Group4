with open('../pulsar_address.txt', 'r') as file:
    pulsar_address = file.readline().strip()  # Read the first line and strip any extra whitespace

import pulsar
client = pulsar.Client(pulsar_address)
consumer = client.subscribe('persistent://Smart_Home/Energy_Management/Energy_Monitoring_Device', subscription_name='energy-monitoring-sub')

# Receive messages
while True:
    msg = consumer.receive()
    print("%s" % msg.data())
    consumer.acknowledge(msg)

client.close()
