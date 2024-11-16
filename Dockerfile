# Use the official Python image as a base
FROM python:3.8-slim-buster

# Set the working directory in the container
WORKDIR /app

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libstdc++6 \
    && rm -rf /var/lib/apt/lists/*

# Copy the requirements file into the container
COPY Demo_CE/requirements.txt .

# Install the dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the setup.py and string.cpp files into the container
COPY Demo_CS/setup.py Demo_CS/string.cpp /app/

# Set the entrypoint to run the Python script
ENTRYPOINT ["python"]