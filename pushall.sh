#!/bin/sh

for i in hadoop hadoop-namenode hadoop-datanode hadoop-nodemanager hadoop-resourcemanager hadoop-historyserver spark spark-historyserver bio; do
  echo pushing $i
  (docker push taroull/$i )
done
