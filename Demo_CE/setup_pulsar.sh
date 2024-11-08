#!/bin/bash

PULSAR_ADMIN="/pulsar/bin/pulsar-admin"

# Wait until the broker is fully ready
echo "Waiting for broker to be fully initialized..."
until $PULSAR_ADMIN clusters list; do
  sleep 5
done
echo "Broker is ready. Proceeding with setup."


# Create tenant
$PULSAR_ADMIN tenants create Smart_Home

# Create namespaces
$PULSAR_ADMIN namespaces create Smart_Home/Environmental_Monitoring
$PULSAR_ADMIN namespaces create Smart_Home/Energy_Management
$PULSAR_ADMIN namespaces create Smart_Home/Security_Surveillance

# Set namespace retention policies
$PULSAR_ADMIN namespaces set-retention Smart_Home/Environmental_Monitoring \
  --size 10M \
  --time -1
$PULSAR_ADMIN namespaces set-retention Smart_Home/Energy_Management \
  --size 10M \
  --time -1
$PULSAR_ADMIN namespaces set-retention Smart_Home/Security_Surveillance \
  --size 10M \
  --time -1

# Create topics under Environmental_Monitoring namespace with retention settings
$PULSAR_ADMIN topics create persistent://Smart_Home/Environmental_Monitoring/Air_Quality_Monitor
$PULSAR_ADMIN topics create persistent://Smart_Home/Environmental_Monitoring/Indoor_Climate_Monitoring_Device

# Create topics under Energy_Management namespace with retention settings
$PULSAR_ADMIN topics create persistent://Smart_Home/Energy_Management/Energy_Monitoring_Device
$PULSAR_ADMIN topics create persistent://Smart_Home/Energy_Management/Appliance_Control_Device

# Create topics under Security_Surveillance namespace with retention settings
$PULSAR_ADMIN topics create persistent://Smart_Home/Security_Surveillance/Security_Device
$PULSAR_ADMIN topics create persistent://Smart_Home/Security_Surveillance/Surveillance_Camera

echo "Pulsar setup completed!"
