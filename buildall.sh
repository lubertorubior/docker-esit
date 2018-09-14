#!/bin/sh

for i in hadoop hadoop-namenode hadoop-datanode hadoop-nodemanager hadoop-resourcemanager hadoop-historyserver jupyter spark spark-historyserver bio web; do
  echo Building $i
  (cd $i && ./build.sh)
done
