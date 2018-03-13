#!/bin/bash

namedir=$(xmlstarlet sel -t -v '//property[name/text() = "dfs.namenode.name.dir"]/value' $HADOOP_CONF_DIR/hdfs-site.xml)
if [ "$(ls -A $namedir)" == "" ]
then
  hdfs namenode -format $CLUSTER_NAME
fi
