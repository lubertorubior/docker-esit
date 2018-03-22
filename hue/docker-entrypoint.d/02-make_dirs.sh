#!/bin/bash

# Create Hive warehouse dir
echo "Creating Hive warehouse directory"
hadoop fs -mkdir -p /user/hive/warehouse
