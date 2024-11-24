# **Project Demonstration on Debian-based Machines**

This guide will help you demonstrate the Smart Home IoT Environmental and Security Monitoring System on Debian-based machines. The project utilizes Apache Pulsar for real-time data streaming and SprintZ compression to efficiently manage and process IoT data for smart home monitoring.

## **Prerequisites**

- Docker and Docker Compose
- GNOME Terminal

## **Setup and Demonstration**

1. **Clone the repository**:
    ```bash
    git clone https://github.com/longnguyencbct/Multidisciplinary_Project_Group4.git
    cd Multidisciplinary_Project_Group4
    ```

2. **Run the setup script**:
    ```bash
    ./setup.sh
    ```
    This script will remove any previous `.so` files and run the `setup.py` script to build the necessary extensions.

3. **Start the Docker containers**:
    ```bash
    docker-compose up --build -d
    ```
    This command will build and start the Docker containers defined in the `docker-compose.yml` file.

4. **Run the demonstration scripts**:

    - **demo1_0_init_dataflow**:
        ```bash
        ./demo/main-demo/demo1_0_init_dataflow
        ```
        This script starts the producer and consumer for the `Air_Quality_Monitor` topic in separate GNOME terminals. It includes a termination function to handle termination signals and ensure proper process termination.

    - **demo1_1_producer_init_dataflow**:
        ```bash
        ./demo/main-demo/demo1_1_producer_init_dataflow
        ```
        This script runs the producer for the `Air_Quality_Monitor` topic in a separate GNOME terminal. The termination function ensures any previously running producer process is killed before starting a new one.

    - **demo1_2_consumer_init_dataflow**:
        ```bash
        ./demo/main-demo/demo1_2_consumer_init_dataflow
        ```
        This script runs the consumer for the `Air_Quality_Monitor` topic in a separate GNOME terminal. It includes a termination function to handle termination signals and ensure any previously running consumer process is terminated.

    - **demo3_0_multi_dataflow**:
        ```bash
        ./demo/main-demo/demo3_0_multi_dataflow
        ```
        This script runs the producer and consumer scripts for multiple topics in separate GNOME terminals. It loops through a list of topics, starting a producer and consumer for each.

    - **demo3_1_multi_producers**:
        ```bash
        ./demo/main-demo/demo3_1_multi_producers
        ```
        This script runs multiple producer scripts for different topics in separate GNOME terminals. It loops through a list of topics, ensuring each producer is started after terminating any previous instances.

    - **demo3_2_multi_consumers**:
        ```bash
        ./demo/main-demo/demo3_2_multi_consumers
        ```
        This script runs multiple consumer scripts for different topics in separate GNOME terminals. It loops through a list of topics, ensuring each consumer is started after terminating any previous instances.

    - **kill_all_producer_consumer**:
        ```bash
        ./demo/main-demo/kill_all_producer_consumer
        ```
        This script terminates all running producer and consumer processes. It ensures a clean state by looping through all topics and stopping their associated processes.

5. **Manage Containers**:

    - **docker-recompose.sh**:
        ```bash
        ./docker-recompose.sh
        ```
        This script stops and removes all containers, rebuilds the Docker images, and restarts the environment. It ensures the latest changes to the project are reflected.

    - **kill_all_consumer**:
        ```bash
        ./kill_all_consumer
        ```
        This script terminates all consumer processes across all topics. It provides a clean slate for restarting consumer scripts.

    - **kill_all_producer**:
        ```bash
        ./kill_all_producer
        ```
        This script terminates all producer processes across all topics. It ensures no lingering producers are running before starting new ones.

    - **kill_all_producer_consumer**:
        ```bash
        ./kill_all_producer_consumer
        ```
        This script terminates both producer and consumer processes across all topics, ensuring all processes are stopped cleanly.

## **What Happens in the Process**

- **Setup Script**: The `setup.sh` script ensures that any previous compiled extensions are removed and rebuilds the necessary extensions using `setup.py`.
- **Docker Containers**: The `docker-compose up` command builds and starts the Docker containers, setting up the environment for the demonstration.
- **Demonstration Scripts**: Each demonstration script runs the producer and/or consumer scripts for the specified topics in separate GNOME terminals, simulating real-time data flow and processing.
- **Termination Scripts**: Scripts like `kill_all_producer`, `kill_all_consumer`, and `kill_all_producer_consumer` provide functionality to cleanly terminate all running processes.

