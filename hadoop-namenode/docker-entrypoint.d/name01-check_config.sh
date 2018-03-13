#!/bin/bash

namedir=$(xmlstarlet sel -t -v '//property[name/text() = "dfs.namenode.name.dir"]/value' $HADOOP_CONF_DIR/hdfs-site.xml)
if [ -z "$namedir" ]
then
  echo "dfs.namenode.name.dir must be specified in hdfs-site.xml"
  exit 2
fi

mkdir -p /opt/holasoyname
