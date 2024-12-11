# **Smart Home IoT Environmental and Security Monitoring System**

This project utilizes Apache Pulsar for real-time data streaming and SprintZ compression to efficiently manage and process IoT data for smart home monitoring. It covers multiple aspects, including energy management, environmental monitoring, and security surveillance.

## **Prerequisites**

- Docker and Docker Compose

## **[Optional] Setting up Pulsar Server (Debian-based OS server only)**
**Guide**: Navigate to [Demo_CE/README.md](Demo_CE/README.md)

This step is optional, because we have a dedicated server that is hosting Smart Home's Apache Pulsar Cluster. 

## **[Optional] Prepare SprintZ Compression**

```sh
cd Demo_CS
python setup.py build_ext --inplace
```

This step is optional, because we have already compiled the string.cpp file into a .so file and it will be used inside the container when you compose it up.

## **[Optional] Setting up Producers, Consumers**
**Guide**: Navigate to [Demo_CE/Topics/README.md](Demo_CE/Topics/README.md)

This step is optional, because we have implemented 6 topics for demonstration, with each of them having 1 producer and 1 consumer. 

## **Setting up Demonstration**
### **Debian-based**: 

**Guide**: Navigate to [demo/main-demo/README.md](demo/main-demo/README.md)

### **Windows**: 

**Guide**: Navigate to [demo/main-demo-windows/README.md](demo/main-demo-windows/README.md)

## Acknowledgements

- [Apache Pulsar](https://pulsar.apache.org/)
- [SprintZ](https://github.com/dblalock/sprintz?tab=readme-ov-file)