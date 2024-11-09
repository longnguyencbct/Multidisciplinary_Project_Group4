# Define the base directory for topics
$BASE_DIR = "../../Demo_CE/Topics"

# Declare an array of topics and script names
$topics = @{
    "Air_Quality_Monitor" = "air_quality_monitor"
    "Appliance_Control_Device" = "appliance_control_device"
    "Energy_Monitoring_Device" = "energy_monitoring_device"
    "Indoor_Climate_Monitoring_Device" = "indoor_climate_monitoring_device"
    "Security_Device" = "security_device"
    "Surveillance_Camera" = "surveillance_camera"
}

# Loop over topics to run each consumer in separate PowerShell windows
foreach ($topic in $topics.Keys) {
    $script_prefix = $topics[$topic]
    $topic_dir = Join-Path $BASE_DIR $topic

    # Open a new PowerShell window for the consumer
    Start-Process powershell -ArgumentList "cd `"$topic_dir`"; python ${script_prefix}_consumer.py"

    # Optional: Sleep interval between each consumer launch
    Start-Sleep -Seconds 1
}
