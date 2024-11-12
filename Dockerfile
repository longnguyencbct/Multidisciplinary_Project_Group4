# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r Demo_CE/requirements.txt

# Install additional dependencies
RUN apt-get update && apt-get install -y \
    g++ \
    make \
    tmux \
    libstdc++-11-dev \
    && rm -rf /var/lib/apt/lists/*

# Compile the SprintZ algorithm
RUN cd Demo_CS && python setup.py build_ext --inplace

# Expose any ports the app runs on
EXPOSE 6650 8080

# Define environment variable
ENV NAME World

# Default command to keep the container running
CMD ["tail", "-f", "/dev/null"]