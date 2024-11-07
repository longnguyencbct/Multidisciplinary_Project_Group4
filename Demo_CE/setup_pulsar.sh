#!/bin/bash

PULSAR_ADMIN="/pulsar/bin/pulsar-admin"

# Create tenant
$PULSAR_ADMIN tenants create Smart_Home

# Create namespaces
$PULSAR_ADMIN namespaces create Smart_Home/Environmental_Monitoring
$PULSAR_ADMIN namespaces create Smart_Home/Energy_Management
$PULSAR_ADMIN namespaces create Smart_Home/Security_Surveillance

# Create topics under Environmental_Monitoring namespace
$PULSAR_ADMIN topics create persistent://Smart_Home/Environmental_Monitoring/Air_Quality_Monitor
$PULSAR_ADMIN topics create persistent://Smart_Home/Environmental_Monitoring/Indoor_Climate_Monitoring_Device

# Create topics under Energy_Management namespace
$PULSAR_ADMIN topics create persistent://Smart_Home/Energy_Management/Energy_Monitoring_Device
$PULSAR_ADMIN topics create persistent://Smart_Home/Energy_Management/Appliance_Control_Device

# Create topics under Security_Surveillance namespace
$PULSAR_ADMIN topics create persistent://Smart_Home/Security_Surveillance/Security_Device
$PULSAR_ADMIN topics create persistent://Smart_Home/Security_Surveillance/Surveillance_Camera

echo "Pulsar setup completed!"
