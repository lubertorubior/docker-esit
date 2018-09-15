# docker-esit

This repository contains a dockerized collection of NGS tools along with Hadoop (HDFS and YARN), Spark, JupyterLab and other complementary software for distributed NGS data processing and analysis. With these Docker images, you can deploy a scalable cluster to be managed using Docker Swarm mode.

The images provide:
* Hadoop 2.8.8
* Spark 2.1
* JupyterLab 0.34.0
* BCFtools 1.8
* BEDtools 2.27.1
* BWA 0.7.17
* Cromwell 34
* FastQC 0.11.7
* GATK 4.0.8.1
* Nextflow 0.28.0
* Picard 2.18.0
* Qualimap 2.2.1
* Rabix 1.0.5
* SAMtools 0.1.19
* Tabix 1.2.1
* VCFtools 0.1.15
* WOMtool 34
* Wgsim 0.3.1

## Prerequisities
In order to run the provided images you'll need Docker installed. These images are tested on Docker CE for Ubuntu 16.04 (Docker version 18.06.1-ce, build e68fc7a).

## Usage
TO DO

## Configuration
TO DO

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
