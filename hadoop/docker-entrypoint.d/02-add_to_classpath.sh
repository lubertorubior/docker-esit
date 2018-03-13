#!/bin/bash

mkdir -p $HADOOP_EXTRA_CLASSPATH
for i in "${ADD_TO_HADOOP_CLASSPATH[@]}"
do
  echo "Downloading lib: ${i}"
  cd "$HADOOP_EXTRA_CLASSPATH"; curl -OJ "${i}"; cd -
done

