FROM taroull/hadoop:2.8.4

# Install pyspark
RUN pip install pyspark
RUN pip3 install -q pyspark

# Set spark environment data
ENV SPARK_VERSION 2.3.2
ENV SPARK_BIN_URL https://www.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-without-hadoop.tgz
ENV SPARK_HOME /opt/spark-$SPARK_VERSION
ENV SPARK_CONF_DIR /etc/spark

# Download and unpack spark in /opt and symlink spark config to /etc/spark
RUN set -x \
    && curl -fSL "$SPARK_BIN_URL" -o /tmp/spark.tar.gz \
    && tar -xvf /tmp/spark.tar.gz -C /opt \
    && mv /opt/spark-$SPARK_VERSION-* $SPARK_HOME \
    && rm -f /tmp/spark.tar.gz \
    && ln -s /opt/spark-$SPARK_VERSION/conf $SPARK_CONF_DIR

# Add spark to path
ENV PATH $SPARK_HOME/bin:$PATH

# Add hadoop classpath to spark environment
RUN echo "export SPARK_DIST_CLASSPATH=$(hadoop classpath)" >> $SPARK_CONF_DIR/spark-env.sh

#COPY conf/spark-defaults.conf $SPARK_CONF_DIR
ADD https://github.com/lubertorubior/docker-esit/raw/master/conf/spark/spark-defaults.conf $SPARK_CONF_DIR

# Add custom libs to the spark classpath
ENV SPARK_EXTRA_CLASSPATH /opt/lib/spark
RUN echo "spark.executor.extraClassPath $SPARK_EXTRA_CLASSPATH" >> $SPARK_CONF_DIR/spark-defaults.conf \
 && echo "spark.driver.extraClassPath $SPARK_EXTRA_CLASSPATH" >> $SPARK_CONF_DIR/spark-defaults.conf

# Add custom libs to the hadoop classpath
ENV HADOOP_EXTRA_CLASSPATH /opt/lib/hadoop
#RUN mkdir -p $HADOOP_EXTRA_CLASSPATH
ENV HADOOP_CLASSPATH $HADOOP_EXTRA_CLASSPATH

# Create default directory
RUN mkdir -p /datos
WORKDIR /datos
