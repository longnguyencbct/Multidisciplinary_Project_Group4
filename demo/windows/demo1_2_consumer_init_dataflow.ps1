# Navigate to the Air_Quality_Monitor directory
Set-Location "../../Demo_CE/Topics/Air_Quality_Monitor"

# Open a new PowerShell window for the consumer
Start-Process powershell -ArgumentList "-NoExit", "python air_quality_monitor_consumer.py"