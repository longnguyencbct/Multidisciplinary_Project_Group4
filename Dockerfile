# Use an official Python runtime as a parent image
FROM python:3.12-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r Demo_CE/requirements.txt

# Install setuptools
RUN pip install --no-cache-dir setuptools

# Install additional dependencies
RUN apt-get update && apt-get install -y \
    g++ \
    make \
    tmux \
    software-properties-common \
    && echo "deb http://deb.debian.org/debian testing main" >> /etc/apt/sources.list \
    && apt-get update && apt-get install -y \
    libstdc++6 \
    && sed -i '/testing/d' /etc/apt/sources.list \
    && rm -rf /var/lib/apt/lists/*

# Compile the SprintZ algorithm
RUN cd Demo_CS && python setup.py build_ext --inplace

# Expose any ports the app runs on
EXPOSE 6650 8080

# Define environment variable
ENV NAME World

# Default command to keep the container running
CMD ["tail", "-f", "/dev/null"]