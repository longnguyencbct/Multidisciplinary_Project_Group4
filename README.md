# Smart Home IoT Environmental and Security Monitoring System

This project utilizes Apache Pulsar for real-time data streaming and SprintZ compression to efficiently manage and process IoT data for smart home monitoring. It covers multiple aspects, including energy management, environmental monitoring, and security surveillance.

## Prerequisites

- Python 3.x
- C++ Compiler (for compiling the SprintZ algorithm)

## Installation

1. **Clone the repository**:
    ```sh
    git clone https://github.com/longnguyencbct/Multidisciplinary_Project_Group4.git
    ```

2. **Compile the SprintZ Algorithm (C++)**:
    Navigate to the directory containing `string.cpp` and compile it into a .so library for Python:
    ```sh
    python setup.py build_ext --inplace
    ```

3. **Add server_address.txt**:
   Navigate to the directory "Demo_CE" and add a file `server_address.txt` with `pulsar://<ip>:<port>` which is the IP and port for the Pulsar server.

## Usage

### Running the Producer
Run each producer script with the format:
```sh
python3 [topic]_producer.py
```

### Running the Consumer
Run each producer script with the format:
```sh
python3 [topic]_consumer.py
```

### Check Dataflow on Pulsar Server
<TODO> Use Pulsar Admin CLI or the Pulsar dashboard to monitor topics, producers, and consumers in real-time.


## Acknowledgements

- [Apache Pulsar](https://pulsar.apache.org/)
- [SprintZ](https://github.com/dblalock/sprintz?tab=readme-ov-file)
