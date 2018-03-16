#!/bin/bash

# Reset font color
COff='\033[0m'       	  # Text Reset
# Regular font colors
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Cyan='\033[0;36m'         # Cyan

echo "---------------------------------"
echo -e "${Cyan}[HADOOP] Testing Hadoop...${COff}"

echo -e "${Cyan}[HADOOP] Creating HDFS directories${COff}"
hadoop fs -mkdir -p hdfs://namenode/test/hadoop/wordcount/input/

echo -e "${Cyan}[HADOOP] Uploading files to HDFS${COff}"
hadoop fs -copyFromLocal input.txt hdfs://namenode/test/hadoop/wordcount/input/

echo -e "${Cyan}[HADOOP] Running Hadoop wordcount${COff}"
hadoop jar wc.jar WordCount2 hdfs://namenode/test/hadoop/wordcount/input/ hdfs://namenode/test/hadoop/wordcount/output/

echo -e "${Cyan}[HADOOP] Hadoop wordcount finished${COff}"
hadoop fs -test -f hdfs://namenode/test/hadoop/wordcount/output/_SUCCESS
if [ $? == 0 ]
then
  echo -e "${Cyan}[HADOOP] Result: ${Green}SUCCESS${COff}"
else
  echo -e "${Cyan}[HADOOP] Result: ${Red}FAILED${COff}"
fi

echo -e "${Cyan}[HADOOP] Cleaning up HDFS directories${COff}"
hadoop fs -rm -r hdfs://namenode/test/hadoop/wordcount/
