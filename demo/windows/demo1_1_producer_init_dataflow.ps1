# Navigate to the Air_Quality_Monitor directory
Set-Location "../../Demo_CE/Topics/Air_Quality_Monitor"

# Open a new PowerShell window for the producer
Start-Process powershell -ArgumentList "-NoExit", "python air_quality_monitor_producer.py"