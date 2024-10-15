import os
import pandas as pd
import numpy as np
from datetime import datetime, timedelta

# Function to generate data for a week with the given base value
def generate_data_for_week(base_value, start_date, end_date):
    timestamps = pd.date_range(start=start_date, end=end_date, freq='H')
    # Random variation between -5% and +5% for each hour
    variation = np.random.uniform(-0.05, 0.05, len(timestamps))
    values = base_value * (1 + variation.cumsum())  # cumulative variation
    df = pd.DataFrame({'timestamp': timestamps, 'value': values})
    return df

# Function to upsample and add minute-level data
def upsample_to_minutes(df):
    # Resample the data from hourly to minute-level (1 minute frequency)
    df.set_index('timestamp', inplace=True)
    df_min = df.resample('T').interpolate(method='linear')  # Interpolate missing minutes
    
    # Add random fluctuation between -0.5% and +0.5% to each minute's value
    fluctuation = np.random.uniform(-0.005, 0.005, len(df_min))
    df_min['value'] = df_min['value'] * (1 + fluctuation)
    
    df_min.reset_index(inplace=True)
    return df_min

# Define the structure of the data
data_structure = {
    "Data/Energy_Monitoring_Device": {
        "total_energy_consumption": 100,  # kWh
        "energy_usage_forecast": 105,  # kWh
        "energy_efficiency_levels": 90  # %
    },
    "Data/Appliance_Control_Device": {
        "appliance_power_usage": 1500,  # W
        "appliance_status_on_off": 1,  # 1 for ON, 0 for OFF
        "smart_thermostat_control": 22  # Celsius
    },
    "Data/Air_Quality_Monitors": {
        "air_quality_index": 50,  # AQI
        "voc_levels": 200,  # PPM
        "pm2_5_levels": 12  # µg/m³
    },
    "Data/Security_Devices": {
        "door_open_close_sensors": 0,  # 0 for closed, 1 for open
        "window_open_close_sensors": 0,  # 0 for closed, 1 for open
        "motion_sensors": 0  # 0 for no motion, 1 for motion detected
    },
    "Data/Surveillance_Cameras": {
        "camera_feed_status": 1,  # 1 for active, 0 for inactive
        "video_data_feed": 500,  # MB/hour
        "suspicious_activity_alerts": 0  # 0 for no alert, 1 for alert
    },
    "Data/Indoor_Climate_Monitoring_Devices": {
        "room_temperature": 23,  # Celsius
        "humidity_levels": 40,  # Percentage
        "co2_levels": 400  # PPM
    }
}

# Set the date range for the data (1 week from 1st September 2024 to 7th September 2024)
start_date = datetime(2024, 9, 1)
end_date = datetime(2024, 9, 7)

# Create directories and generate combined data files for each IoT device
for device, topics in data_structure.items():
    os.makedirs(f"Demo/{device}", exist_ok=True)
    combined_data = pd.DataFrame()

    # Generate data for each topic and combine them
    for topic, base_value in topics.items():
        df = generate_data_for_week(base_value, start_date, end_date)
        df_min = upsample_to_minutes(df)  # Upsample to minute-level
        combined_data['timestamp'] = df_min['timestamp']
        combined_data[topic] = df_min['value']

    # Save the combined data to one CSV file per device
    csv_path = f"Demo/{device}/{device.split('/')[-1].lower()}.csv"
    combined_data.to_csv(csv_path, index=False)

# Confirming the completion
csv_dirs = [os.path.join(device, f"{device.split('/')[-1].lower()}.csv") for device in data_structure]
csv_dirs
