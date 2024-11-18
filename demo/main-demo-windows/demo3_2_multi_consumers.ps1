# Define the base directory for topics
$BASE_DIR = "Demo_CE/Topics"

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
    Write-Host "Terminating processes..."
    docker exec -it init-setup sh -c "pkill -f python"
    Write-Host "Processes terminated."
}

# Trap terminal close signal
trap {
    Terminate
    continue
} -SignalName SIGINT, SIGTERM

# Terminate any existing processes inside the container
Write-Host "Terminating any existing processes inside the container..."
docker exec -it init-setup sh -c "pkill -f python"
Write-Host "Existing processes terminated."

# Loop over topics to run each consumer in separate Command Prompt windows
foreach ($topic in $topics.Keys) {
    $script_prefix = $topics[$topic]
    $topic_dir = "$BASE_DIR/$topic"

    # Open a new Command Prompt window for the consumer
    Write-Host "Opening a new Command Prompt window for the consumer for topic: $topic..."
    Start-Process -FilePath "cmd.exe" -ArgumentList "/K docker exec -it init-setup sh -c `"cd '$topic_dir' && python ${script_prefix}_consumer.py`""
    Write-Host "Consumer window for topic: $topic opened."

    # Adding delay for new process to start
    Start-Sleep -Seconds 1
}

# Wait for all background processes to finish
Write-Host "Waiting for all background processes to finish..."
Wait-Process
