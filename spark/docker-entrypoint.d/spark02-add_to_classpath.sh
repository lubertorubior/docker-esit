#!/bin/bash

mkdir -p /opt/ejecutosecun

mkdir -p $SPARK_EXTRA_CLASSPATH
for i in "${ADD_TO_SPARK_CLASSPATH[@]}"
do
  echo "Downloading lib: ${i}"
  cd $SPARK_EXTRA_CLASSPATH; curl -OJ ${i}; cd -
done