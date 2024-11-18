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

# Open a new Command Prompt window for the producer
Write-Host "Opening a new Command Prompt window for the producer..."
Start-Process -FilePath "cmd.exe" -ArgumentList "/K docker exec -it init-setup sh -c ""cd Demo_CE/Topics/Air_Quality_Monitor && python air_quality_monitor_producer.py"""
Write-Host "Producer window opened."

# Adding delay for new process to start
Start-Sleep -Seconds 1

# Wait for all background processes to finish
Write-Host "Waiting for all background processes to finish..."
Wait-Process