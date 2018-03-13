FROM ubuntu:16.04

# Set java home
RUN apt-get update && apt-get install -y \
    openjdk-8-jre-headless \
    ca-certificates-java \
    && rm -rf /var/lib/apt/lists/*
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/

# Install packages
RUN apt-get update && apt-get install -y \
    net-tools \
    curl \
    nano \
    netcat-openbsd \
    xmlstarlet \
    zip \
    python \
    python-pip \
    python3.5 \
    python3-pip
RUN pip install pip --upgrade
#RUN pip install pyspark
RUN pip3 install -q --upgrade pip
#RUN pip3 install -q pyspark

# Set hadoop environment data
ENV HADOOP_VERSION 2.8.3
ENV HADOOP_URL https://www.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz
ENV HADOOP_PREFIX /opt/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR /etc/hadoop

# Download and unpack hadoop in /opt and symlink hadoop config to /etc/hadoop
RUN curl -fSL "$HADOOP_URL" -o /tmp/hadoop.tar.gz \
    && curl -fSL "$HADOOP_URL.asc" -o /tmp/hadoop.tar.gz.asc \
    && tar -xvf /tmp/hadoop.tar.gz -C /opt/ \
    && rm /tmp/hadoop.tar.gz* \
    && ln -s $HADOOP_PREFIX/etc/hadoop $HADOOP_CONF_DIR \
    && cp $HADOOP_CONF_DIR/mapred-site.xml.template $HADOOP_CONF_DIR/mapred-site.xml

# Add custom libs to the hadoop classpath
ENV HADOOP_EXTRA_CLASSPATH /opt/lib/hadoop
#RUN mkdir -p $HADOOP_EXTRA_CLASSPATH
ENV HADOOP_CLASSPATH $HADOOP_EXTRA_CLASSPATH/*

# Add hadoop to path
ENV PATH $HADOOP_PREFIX/bin/:$PATH

# Make the hadoop directory writable
#RUN mkdir /var/hadoop

# Download config files
#COPY conf $HADOOP_CONF_DIR
ADD https://github.com/lubertorubior/docker-esit/raw/master/conf/hadoop/core-site.xml $HADOOP_CONF_DIR
ADD https://github.com/lubertorubior/docker-esit/raw/master/conf/hadoop/hdfs-site.xml $HADDOP_CONF_DIR
ADD https://github.com/lubertorubior/docker-esit/raw/master/conf/hadoop/mapred-site.xml $HADDOP_CONF_DIR
ADD https://github.com/lubertorubior/docker-esit/raw/master/conf/hadoop/yarn-site.xml $HADDOP_CONF_DIR

# Set flexible entrypoints scripts
COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
COPY ./docker-entrypoint.d/* /docker-entrypoint.d/
ONBUILD COPY /docker-entrypoint.d/* /docker-entrypoint.d/
ONBUILD RUN chmod +x /docker-entrypoint.d/*
ENTRYPOINT ["/entrypoint.sh"]
CMD ["--no-daemonize"]
