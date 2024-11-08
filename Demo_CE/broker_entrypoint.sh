#!/bin/bash
set -e

# Directly apply configurations to conf/broker.conf
config_file="conf/broker.conf"

echo "Configuring broker environment in $config_file..."

# Update each configuration in broker.conf
sed -i "s/^metadataStoreUrl=.*/metadataStoreUrl=zk:zookeeper:2181/" $config_file
sed -i "s/^zookeeperServers=.*/zookeeperServers=zookeeper:2181/" $config_file
sed -i "s/^clusterName=.*/clusterName=cluster-a/" $config_file
sed -i "s/^managedLedgerDefaultEnsembleSize=.*/managedLedgerDefaultEnsembleSize=1/" $config_file
sed -i "s/^managedLedgerDefaultWriteQuorum=.*/managedLedgerDefaultWriteQuorum=1/" $config_file
sed -i "s/^managedLedgerDefaultAckQuorum=.*/managedLedgerDefaultAckQuorum=1/" $config_file
sed -i "s/^advertisedAddress=.*/advertisedAddress=broker/" $config_file
sed -i "s/^advertisedListeners=.*/advertisedListeners=external:pulsar:\/\/127.0.0.1:6650/" $config_file
sed -i "s/^brokerDeleteInactiveTopicsEnabled=.*/brokerDeleteInactiveTopicsEnabled=false/" $config_file

# Start the broker
echo "Starting Pulsar broker with applied configurations..."
bin/pulsar broker &

# Wait for the broker to become available on port 8080
echo "Waiting for broker to be fully initialized..."
RETRY_COUNT=0
MAX_RETRIES=20
until curl -s http://localhost:8080/admin/v2/tenants || [ "$RETRY_COUNT" -eq "$MAX_RETRIES" ]; do
    echo "Broker not available yet. Retrying in 5 seconds..."
    RETRY_COUNT=$((RETRY_COUNT + 1))
    sleep 5
done

if [ "$RETRY_COUNT" -eq "$MAX_RETRIES" ]; then
    echo "Failed to connect to broker after multiple attempts. Exiting."
    exit 1
fi

# Run the setup script if broker is available
echo "Running setup script..."
bash /pulsar/setup_pulsar.sh

# Run list entities script after setup
echo "Running list entities script..."
bash /pulsar/list_pulsar_entities.sh

# Keep the broker running in the foreground
wait
