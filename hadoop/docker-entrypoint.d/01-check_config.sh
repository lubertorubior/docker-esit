#!/bin/bash

defaultfs=$(xmlstarlet sel -t -v '//property[name/text() = "fs.defaultFS"]/value' $HADOOP_CONF_DIR/core-site.xml)
if [ -z "$defaultfs" ]
then
  echo "fs.defaultFS must be specified in core-site.xml"
  exit 2
fi
