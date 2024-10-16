with open('../../server_address.txt', 'r') as file:
    pulsar_address = file.readline().strip()  # Read the first line and strip any extra whitespace

import pulsar
client = pulsar.Client(pulsar_address)
consumer = client.subscribe('persistent://Smart_Home/Environmental_Monitoring/Indoor_Climate_Monitoring_Devices', subscription_name='indoor-climate-sub')

# Receive messages
while True:
    msg = consumer.receive()
    print("%s" % msg.data())
    consumer.acknowledge(msg)

client.close()
