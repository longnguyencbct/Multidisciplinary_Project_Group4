# Declare an array of topics and script names
$topics = @{
    "Air_Quality_Monitor" = "air_quality_monitor"
    "Appliance_Control_Device" = "appliance_control_device"
    "Energy_Monitoring_Device" = "energy_monitoring_device"
    "Indoor_Climate_Monitoring_Device" = "indoor_climate_monitoring_device"
    "Security_Device" = "security_device"
    "Surveillance_Camera" = "surveillance_camera"
}

# Function to terminate all producer and consumer processes
function TerminateAll {
    Write-Output "Terminating all producer and consumer processes..."
    foreach ($topic in $topics.Keys) {
        $scriptPrefix = $topics[$topic]
        
        # Use bash command inside the container to terminate processes
        docker exec -it init-setup /bin/bash -c "pkill -f ${scriptPrefix}_producer.py"
        docker exec -it init-setup /bin/bash -c "pkill -f ${scriptPrefix}_consumer.py"
    }
    Write-Output "All producer and consumer processes terminated."
}

TerminateAll
