# **Smart Home's Apache Pulsar Deployment on Debian-based OS Server**

This guide will help you to deploy Apache Pulsar on a Debian-based OS server, which is a crutial component of the Smart Home IoT Environmental and Security Monitoring System. The project utilizes Apache Pulsar for real-time data streaming and SprintZ compression to efficiently manage and process IoT data for smart home monitoring.

## **Prerequisites**

- Docker and Docker Compose
- GNOME Terminal

## **Initial Setup**

1. **Clone the repository**:
    ```bash
    git clone https://github.com/longnguyencbct/Multidisciplinary_Project_Group4.git
    cd Multidisciplinary_Project_Group4/Demo_CE
    ```

2. **Start the Docker containers**:
    ```bash
    docker-compose up --build -d
    ```
    This command will build and start the Docker containers defined in the `docker-compose.yml` file.

3.  **Disable Firewalls**
    
    Make sure that the firewall for port `6650` is disabled so the Pulsar Broker can listen to producers and publish data to consumers

## **Setup new Topic**

1. **Navigate to setup_pulsar.sh**

    Navigate to /Demo_CE/setup_pulsar.sh

3. **Add Namespace & define retention policies (Optional)**
    - Add the following line to add namespace:
    ```sh
    $PULSAR_ADMIN namespaces create Smart_Home/[your_namespace]
    ```

    - Add the following line to define its retention policies:
    ```sh
    $PULSAR_ADMIN namespaces set-retention Smart_Home/[your_namespace] \
        --size 10M \
        --time -1
    ```

4. **Add Topic**

    Add the following line:
    ```sh
    $PULSAR_ADMIN topics create persistent://Smart_Home/[your_namespace]/[your_topic]

    ```

5. **Compose the yml file again to update the server**

    Type in your terminal:
    ```sh
    docker compose down -v
    docker compose up --build -d
    ```