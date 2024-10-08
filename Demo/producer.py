import pulsar
client = pulsar.Client('pulsar://localhost:6650')
producer = client.create_producer('persistent://conference/ps/first')
producer.send(('Simple Text Message').encode('utf-8'))
client.close()
