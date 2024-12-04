# **Smart Home's Producer/Consumer Setup in Python**

## **Prerequisites**

- Docker and Docker Compose
- Python version > `3.10` 

## **Producer Setup**

1. **Create folder in /Demo_CE/Topics**

    Create a folder and name it ideally by the Topic on Pulsar Broker (if not already done)
    ```sh
    mkdir [your_topic]
    ```

2. **Create a python file**
    Create a python file and name it ideally based on this format: `[your_topic]_producer.py`

3. **Copy the content of any `producer.py` files on other Topics folder and paste it on your `[your_topic]_producer.py`**

4. **Change the corresponding information of the Topics to your own topic that you have set up in the pulsar server**

    For example, change from
    ```py
    producer = client.create_producer('persistent://Smart_Home/Environmental_Monitoring/Air_Quality_Monitor')
    ```
    to
    ```py
    producer = client.create_producer('persistent://Smart_Home/[your_namespace]/[your_topic]')
    ```

5. **You are good to add other functionalities based on your requirements from now on**

## **Consumer Setup**

1. **Similar to `Producer Setup` from step 1 to step 4**

2. **Add an empty file `prev_row.txt` to the current Topic directory**

    This file is required so that the cunsomer will store the previous value of the time-series data in order to perform SprintZ Compression.

3. **You are good to add other functionalities based on your requirements from now on**
