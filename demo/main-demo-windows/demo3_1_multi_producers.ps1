# Declare an array of topics and script names
$topics = @{
    "Air_Quality_Monitor" = "air_quality_monitor"
    "Appliance_Control_Device" = "appliance_control_device"
    "Energy_Monitoring_Device" = "energy_monitoring_device"
    "Indoor_Climate_Monitoring_Device" = "indoor_climate_monitoring_device"
    "Security_Device" = "security_device"
    "Surveillance_Camera" = "surveillance_camera"
}

# Function to handle termination
function Terminate {
    Write-Output "Terminating processes..."
    foreach ($topic in $topics.Keys) {
        $script_prefix = $topics[$topic]
        docker exec -it init-setup /bin/bash -c "pkill -f ${script_prefix}_producer.py"
    }
    exit
}

# Trap termination signals
Register-EngineEvent PowerShell.Exiting -Action { Terminate }

# Terminate any existing producer processes inside the container
foreach ($topic in $topics.Keys) {
    $script_prefix = $topics[$topic]
    docker exec -it init-setup /bin/bash -c "pkill -f ${script_prefix}_producer.py"
}

# Loop over topics to run each producer in separate terminals
foreach ($topic in $topics.Keys) {
    $script_prefix = $topics[$topic]

    # Start producer in a new terminal
    Start-Process powershell -ArgumentList '-NoExit', '-Command', "docker exec -it init-setup /bin/bash -c 'cd /app/Demo_CE/Topics/$topic && python3 ${script_prefix}_producer.py'"

    # Optional: Sleep between launches
    Start-Sleep -Seconds 1
}

# Wait indefinitely
Start-Sleep -Seconds ([int]::MaxValue)
