#!/bin/bash
set -e

# Apply environment variables to broker.conf
sed -i "s/^brokerDeleteInactiveTopicsEnabled=.*/brokerDeleteInactiveTopicsEnabled=false/" conf/broker.conf

# Start the broker
exec bin/pulsar broker &
sleep 20

# Run the setup script if needed
bash /pulsar/setup_pulsar.sh

# Keep the broker running in the foreground
wait
