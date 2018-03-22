FROM taroull/hadoop:2.8.3 as hadoop
FROM gethue/hue:latest

# Download useful packages
RUN apt-get install -y \
    nano \
    xmlstarlet

# Set java home
RUN add-apt-repository ppa:jonathonf/openjdk \
    && apt-get update \
    && apt-get install -y \
    openjdk-8-jdk
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/

# Set hadoop environment data
ENV HADOOP_VERSION 2.8.3
ENV HADOOP_PREFIX /opt/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR /etc/hadoop
ENV HADOOP_EXTRA_CLASSPATH /opt/lib/hadoop

# Copy hadoop data from spark image
COPY --from=hadoop $HADOOP_PREFIX $HADOOP_PREFIX
RUN ln -s $HADOOP_PREFIX/etc/hadoop $HADOOP_CONF_DIR

# Add hadoop to path
ENV PATH $HADOOP_PREFIX/bin:$PATH
ENV HADOOP_CLASSPATH $HADOOP_EXTRA_CLASSPATH

COPY ./conf/pseudo-distributed.ini /hue/desktop/conf/pseudo-distributed.ini

# Http
EXPOSE 8888

# Copy entrypoint scripts
COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
COPY ./docker-entrypoint.d/* /docker-entrypoint.d/
RUN chmod +x /docker-entrypoint.d/*
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/hue/build/env/bin/hue", "runserver_plus", "0.0.0.0:8888"]
