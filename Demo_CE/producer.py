with open('server_address.txt', 'r') as file:
    pulsar_address = file.readline().strip()  # Read the first line and strip any extra whitespace

import pulsar
client = pulsar.Client(pulsar_address)
producer = client.create_producer('persistent://conference/ps/first')
producer.send(('Hello, World!').encode('utf-8'))
client.close()
