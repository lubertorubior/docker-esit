#!/bin/bash

mkdir -p /opt/holis

function mk_config_dir() {
  dir=$(sed -n "s/^${1}[[:space:]]\+//p" $SPARK_CONF_DIR/spark-defaults.conf | sed -e 's/file:\/\//''/')
  if [[ $dir =~ ^hdfs://* ]]
  then
    hadoop fs -mkdir -p "$dir"
  elif [[ $dir =~ ^/* ]]
  then
    mkdir -p "$dir"
  fi
}

#mk_config_dir "spark.eventLog.dir"
mk_config_dir "spark.history.fs.logDirectory"
