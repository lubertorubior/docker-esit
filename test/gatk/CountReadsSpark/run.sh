#!/bin/bash

# Reset
COff='\033[0m'       # Text Reset
# Regular Colors
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Cyan='\033[0;36m'         # Cyan

echo "---------------------------------"
echo -e "${Cyan}[GATK] Testing GATK...${COff}"

echo -e "${Cyan}[GATK] Creating HDFS directories${COff}"
hadoop fs -mkdir -p hdfs://namenode/test/gatk/countreadsspark/

echo -e "${Cyan}[GATK] Uploading files to HDFS${COff}"
hadoop fs -copyFromLocal r.* hdfs://namenode/test/gatk/countreadsspark/

echo -e "${Cyan}[GATK] Running GATK CountReadsSpark${COff}"
gatk CountReadsSpark -I hdfs://namenode/test/gatk/countreadsspark/r.bam -O hdfs://namenode/test/gatk/countreadsspark/output -- --spark-runner SPARK --spark-master yarn --deploy-mode cluster

echo -e "${Cyan}[GATK] GATK CountReadsSpark finished${COff}"
hadoop fs -test -f hdfs://namenode/test/gatk/countreadsspark/output
if [ $? == 0 ]
then
  echo -e "${Cyan}[GATK] Result: ${Green}SUCCESS${COff}"
else
  echo -e "${Cyan}[GATK] Result: ${Red}FAILED${COff}"
fi

echo -e "${Cyan}[GATK] Cleaning up HDFS directories${COff}"
hadoop fs -rm -r hdfs://namenode/test/gatk/countreadsspark/
