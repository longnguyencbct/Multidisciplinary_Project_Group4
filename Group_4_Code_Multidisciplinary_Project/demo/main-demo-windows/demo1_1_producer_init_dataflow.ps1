# Function to handle termination
function Terminate {
    Write-Output "Terminating processes..."
    docker exec -it init-setup /bin/bash -c "pkill -f air_quality_monitor_producer.py"
    exit
}

# Trap termination signals
Register-EngineEvent PowerShell.Exiting -Action { Terminate }

# Terminate any existing producer processes inside the container
docker exec -it init-setup /bin/bash -c "pkill -f air_quality_monitor_producer.py"

# Start producer in a new terminal
Start-Process powershell -ArgumentList '-NoExit', '-Command', "docker exec -it init-setup /bin/bash -c 'cd /app/Demo_CE/Topics/Air_Quality_Monitor && python3 air_quality_monitor_producer.py'"

# Wait indefinitely
Start-Sleep -Seconds ([int]::MaxValue)
