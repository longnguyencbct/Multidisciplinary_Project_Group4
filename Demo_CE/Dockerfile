# Dockerfile
FROM apachepulsar/pulsar:latest

# Copy the scripts into the container
COPY setup_pulsar.sh /pulsar/setup_pulsar.sh
COPY list_pulsar_entities.sh /pulsar/list_pulsar_entities.sh

# Set permissions as root
USER root
RUN chmod 777 /pulsar/setup_pulsar.sh /pulsar/list_pulsar_entities.sh

# Optionally, switch back to non-root user if needed
# USER pulsar  # Uncomment if the container should run as non-root

