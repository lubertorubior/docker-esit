![](https://user-images.githubusercontent.com/10713136/48260380-2faa4680-e413-11e8-96dd-e855aee7634b.png)

# Dockerized Bioinformatic architecture based on Big Data technologies to process data from whole-genome sequencing

This repository presents a Docker container-based infrastructure for NGS data analysis comprising Bioinformatics and Big Data tools (Hadoop and Spark). There are Docker images available for the Hadoop and Spark components and a set of bioinformatics software, including QC applications (FastQC, MultiQC, Qualimap2), aligners (BWA), variant callers (GATK4, Platypus), and other supplementary software (JupyterLab). See list below:

![](https://user-images.githubusercontent.com/10713136/48264600-f88f6180-e421-11e8-9411-c358a7e6c333.png)

This application is supposed to be deployed in a cluster of nodes for best performance but it will also work on a single node. Docker Compose is used for multi-container definition and Docker Swarm for container orchestration and cluster management.

![](https://user-images.githubusercontent.com/10713136/48264468-8028a080-e421-11e8-8c8e-4db2bac7cc9a.png)

See this [poster]() if you want to know more this project.

# Contents
* [Background](#background)
* [Getting started](#getting-started)
* [Usage](#usage)
* [Interfaces](#interfaces)

## Background
Next-generation Sequencing (NGS) data imposes major challenges for processing due to its volume and complexity. Analysis of NGS data is generally based on many third party software, which are sometimes complex to install, configure and usually have dependencies that may lead to portability and reproducibility issues. Thus, it is necessary to develop infrastructures to store, manage and analyse massive genomic data in an efficient, scalable and reproducible way.

## Getting started
In order to run the provided images you'll need Docker installed. These images are tested on Docker CE for Ubuntu 16.04 (Docker version 18.06.1-ce, build e68fc7a). Once you have Docker installed, [follow the instructions in this README to get started.](#usage)

## Usage
Simply follow the instructions in the Docker documentation on how to create a Swarm. This documentation will show you how to manually initialize and add nodes to a Docker Swarm cluster.

Run in this directory:
```
./runall.sh
docker-compose up
```
The app will be available at [http://localhost:80](http://localhost:80).

Alternately, if you want to run it on a [Docker Swarm](https://docs.docker.com/engine/swarm/), first make sure you have a swarm. If you don't, run:
```
docker swarm init
```
Once you have your swarm, in this directory run:
```
docker stack deploy --compose-file docker-compose.yml docker-esit
```

## Interfaces
There is one main interface available on http://localhost:80 to access the different services, which are listed below:

| Service name | Port |
| ------------ | ---- |
| Hadoop HDFS NameNode | http://localhost:50070 |
| Hadoop HDFS DataNode | http://localhost:50075 |
| Hadoop YARN | http://localhost:8088 |
| Hadoop History Server | http://localhost:8188 |
| Spark History Server | http://localhosst:8288 |
| JupyterLab | http://localhost:8888 |
| Livy | http://localhost:8998 |
| Docker Visualizer | http://localhost:7000 |
| Portainer | http://localhost:9000 |

## Acknowledgements
Funded by Ministerio de Ciencia, Innovación y Universidades (RTC-2017-6471-1; MINECO/AEI/FEDER, UE) and also supported by the CEDeI program (Centro de Excelencia de Desarrollo e Innovación, Cabildo de Tenerife). Special thanks to the TARO research group at Universidad de La Laguna for their guidance and support.

![](https://user-images.githubusercontent.com/10713136/48264746-79e6f400-e422-11e8-8444-062a38091f58.png)
