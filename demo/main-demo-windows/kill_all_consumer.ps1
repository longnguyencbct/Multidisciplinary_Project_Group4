# Array of topics
$topics = @{
    "Air_Quality_Monitor" = "air_quality_monitor"
    "Appliance_Control_Device" = "appliance_control_device"
    "Energy_Monitoring_Device" = "energy_monitoring_device"
    "Indoor_Climate_Monitoring_Device" = "indoor_climate_monitoring_device"
    "Security_Device" = "security_device"
    "Surveillance_Camera" = "surveillance_camera"
}

# Terminate all consumer processes
function TerminateAll {
    Write-Output "Terminating all consumer processes..."
    foreach ($topic in $topics.Keys) {
        $scriptPrefix = $topics[$topic]
        docker exec -it init-setup powershell -Command "Stop-Process -Name ${scriptPrefix}_consumer.py -Force"
    }
    Write-Output "All consumer processes terminated."
}

TerminateAll
