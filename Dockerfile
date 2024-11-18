# Use the official Python image from the Docker Hub
FROM python:3.10-slim-buster

# Set the working directory in the container
WORKDIR /app

# Clean up the cache and update the package list
RUN apt-get clean && apt-get update --allow-releaseinfo-change --allow-insecure-repositories && \
    apt-get install -y build-essential libstdc++6 software-properties-common && \
    apt-get install -y gcc g++ procps && \
    rm -rf /var/lib/apt/lists/*

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r /app/Demo_CE/requirements.txt

# Run the setup.py script
RUN cd /app/Demo_CS && python setup.py build_ext --inplace

# Command to keep the container running
CMD ["tail", "-f", "/dev/null"]