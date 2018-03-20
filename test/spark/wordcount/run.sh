#!/bin/bash

# Reset
COff='\033[0m'       # Text Reset
# Regular Colors
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Cyan='\033[0;36m'         # Cyan

echo -e "${Cyan}---------------------------------${COff}"
echo -e "${Cyan}[SPARK] Testing Spark...${COff}"

echo -e "${Cyan}[SPARK] Creating HDFS directories${COff}"
hadoop fs -mkdir -p hdfs://namenode/test/spark/wordcount/input/

echo -e "${Cyan}[SPARK] Uploading files to HDFS${COff}"
hadoop fs -copyFromLocal input.txt hdfs://namenode/test/spark/wordcount/input/

echo -e "${Cyan}[SPARK] Running Spark wordcount${COff}"
spark-submit --master yarn --deploy-mode cluster wordcount.py hdfs://namenode/test/spark/wordcount/input/ hdfs://namenode/test/spark/wordcount/output/

echo -e "${Cyan}[SPARK] Spark wordcount finished${COff}"
hadoop fs -test -f hdfs://namenode/test/spark/wordcount/output/_SUCCESS
if [ $? == 0 ]
then
  echo -e "${Cyan}[SPARK] Result: ${Green}SUCCESS${COff}"
else
  echo -e "${Cyan}[SPARK] Result: ${Red}FAILED${COff}"
fi

echo -e "${Cyan}[SPARK] Cleaning up HDFS directories${COff}"
hadoop fs -rm -r hdfs://namenode/test/spark/wordcount/
