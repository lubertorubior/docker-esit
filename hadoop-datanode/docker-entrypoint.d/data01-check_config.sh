#!/bin/bash

datadir=$(xmlstarlet sel -t -v '//property[name/text() = "dfs.datanode.data.dir"]/value' $HADOOP_CONF_DIR/hdfs-site.xml)
if [ ! -d $datadir ]
then
  echo "dfs.datanode.data.dir must be specified in hdfs-site.xml"
  exit 2
fi

mkdir -p /opt/holasoydata
