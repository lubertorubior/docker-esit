FROM taroull/spark:2.3.1 as spark
FROM jupyter/all-spark-notebook

#USER root
#RUN pip install --upgrade setuptools

#USER $NB_USER
#RUN pip install --upgrade jupyter

# Set hadoop and spark environment data
ENV HADOOP_VERSION 2.8.4
ENV HADOOP_PREFIX /usr/local/hadoop-$HADOOP_VERSION
ENV HADOOP_HOME /usr/local/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR $HADOOP_PREFIX/etc/hadoop
ENV HADOOP_EXTRA_CLASSPATH /opt/lib/hadoop
ENV HADOOP_COMMON_LIB_NATIVE_DIR $HADOOP_HOME/lib/native
ENV HADOOP_OPTS "-Djava.library.path=$HADOOP_COMMON_LIB_NATIVE_DIR"
ENV SPARK_EXTRA_CLASSPATH /opt/lib/spark
ENV LIVY_VERSION 0.4.0
#ENV PYSPARK_PYTHON /usr/bin/python3
#ENV PYSPARK_DRIVER_PYTHON ipython3
#ENV PYSPARK_DRIVER_PYTHON_OPTS "notebook"

USER root

# Set java home
RUN apt-get update && apt-get install -y \
    openjdk-8-jre-headless \
    ca-certificates-java \
    && rm -rf /var/lib/apt/lists/*
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/

# Install some useful packages
RUN apt-get upgrade && apt-get update \
    && apt-get install -y xmlstarlet
    #\
    #&& apt-get install -y python3-pip

# Set hadoop and spark environment data
#ENV HADOOP_VERSION 2.8.4
#ENV HADOOP_PREFIX /usr/local/hadoop-$HADOOP_VERSION
#ENV HADOOP_CONF_DIR /usr/local/hadoop-$HADOOP_VERSION/etc/hadoop
#ENV HADOOP_EXTRA_CLASSPATH /opt/lib/hadoop
#ENV SPARK_VERSION 2.3.0
#ENV SPARK_HOME /usr/local/spark
#ENV SPARK_CONF_DIR /etc/spark
#ENV SPARK_EXTRA_CLASSPATH /opt/lib/spark

# Copy hadoop data from spark image
COPY --from=spark /opt/hadoop-$HADOOP_VERSION $HADOOP_PREFIX
#RUN ln -s $HADOOP_PREFIX/etc/hadoop $HADOOP_CONF_DIR

# Add hadoop to path
ENV PATH $HADOOP_PREFIX/bin:$PATH
ENV HADOOP_CLASSPATH $HADOOP_EXTRA_CLASSPATH

# Copy spark data from spark image
#COPY --from=spark $SPARK_HOME $SPARK_HOME
#RUN ln -s $SPARK_HOME/conf $SPARK_CONF_DIR

# Add hadoop and spark to path
#ENV PATH $SPARK_HOME/bin:$HADOOP_PREFIX/bin:$PATH
#ENV HADOOP_CLASSPATH $HADOOP_EXTRA_CLASSPATH

# Copy hadoop data from spark image
#COPY --from=spark /opt/hadoop-$HADOOP_VERSION $HADOOP_PREFIX
#RUN ln -s $HADOOP_PREFIX/etc/hadoop $HADOOP_CONF_DIR

# Copy spark conf from spark image
COPY --from=spark /etc/spark/spark-defaults.conf $SPARK_HOME/conf/spark-defaults.conf
#RUN sed -i '/avro/d' $SPARK_HOME/conf/spark-defaults.conf

# Remove current spark symlink
#RUN rm /usr/local/spark
#RUN rm $SPARK_HOME

# Add new symlinks
#RUN ln -s /usr/local/spark-$SPARK_VERSION $SPARK_HOME
#RUN ln -s /usr/local/spark-$SPARK_VERSION/conf $SPARK_CONF_DIR

# Add volume
#VOLUME /notebooks
#WORKDIR /notebooks

COPY conf/spark-env.sh /usr/local/spark/conf/spark-env.sh
# Grant $NB_USER
RUN mkdir -p $HADOOP_EXTRA_CLASSPATH $SPARK_EXTRA_CLASSPATH
RUN fix-permissions $HADOOP_PREFIX && \
    #fix-permissions $HADOOP_CONF_DIR && \
    fix-permissions $HADOOP_EXTRA_CLASSPATH && \
    fix-permissions $SPARK_HOME/conf/spark-defaults.conf && \
    fix-permissions $SPARK_HOME/conf/spark-env.sh && \
    #fix-permissions $SPARK_CONF_DIR && \
    fix-permissions $SPARK_EXTRA_CLASSPATH

# Download and unpack livy
RUN curl -fSL http://archive.apache.org/dist/incubator/livy/${LIVY_VERSION}-incubating/livy-${LIVY_VERSION}-incubating-bin.zip -o /tmp/livy.zip \
    && unzip /tmp/livy.zip -d /usr/local/ \
    && rm /tmp/livy.zip* \
    && mkdir /usr/local/livy-${LIVY_VERSION}-incubating-bin/logs \
    && fix-permissions /usr/local/livy-${LIVY_VERSION}-incubating-bin/

# Copy livy conf
COPY conf/livy/* /usr/local/livy-${LIVY_VERSION}-incubating-bin/conf/

# livy server
EXPOSE 8998

RUN fix-permissions /home/jovyan/.cache/ \
  && pip install --upgrade pip \
  && pip install pyspark
  #\
  #&& pip3 install pyspark

# Install sparkmagic
RUN pip install pandas==0.22.0 \
 && pip install sparkmagic

# Enable notebook extension
RUN jupyter nbextension enable --py --sys-prefix widgetsnbextension

# Install wrapper kernels
WORKDIR /opt/conda/lib/python3.6/site-packages/
RUN jupyter-kernelspec install sparkmagic/kernels/sparkkernel --user \
 && jupyter-kernelspec install sparkmagic/kernels/pysparkkernel --user \
 && jupyter-kernelspec install sparkmagic/kernels/pyspark3kernel --user \
 && jupyter-kernelspec install sparkmagic/kernels/sparkrkernel --user

# Copy sparkmagic conf
COPY conf/sparkmagic/* /home/jovyan/.sparkmagic/

# Enable server extension
RUN jupyter serverextension enable --py sparkmagic

# Create workdir
RUN mkdir /notebooks \
 && fix-permissions /notebooks
WORKDIR /notebooks
#RUN chown :users /notebooks

# Set jupyter token
ENV JUPYTER_TOKEN bigdata

# Http
EXPOSE 8888

#USER root

#RUN jupyter toree install --sys-prefix --spark_opts="--master yarn --deploy-mode cluster" --interpreters=PySpark

# Copy entrypoint scripts
COPY --from=spark /entrypoint.sh /entrypoint.sh
RUN fix-permissions /entrypoint.sh && chmod +x /entrypoint.sh
COPY ./docker-entrypoint.d/* /docker-entrypoint.d/
COPY --from=spark /docker-entrypoint.d/ /docker-entrypoint.d/
RUN fix-permissions /docker-entrypoint.d/ && chmod +x /docker-entrypoint.d/*
#ENTRYPOINT ["/entrypoint.sh", "notebook"]
#CMD ["jupyter", "notebook", "--notebook-dir", "/notebooks", "--no-browser", "--allow-root"]

#CMD ["jupyter", "notebook", "--notebook-dir", "/notebooks", "--no-browser", "--allow-root", "--ip='0.0.0.0'"]

#RUN pip install https://dist.apache.org/repos/dist/dev/incubator/toree/0.2.0/snapshots/dev1/toree-pip/toree-0.2.0.dev1.tar.gz
#RUn fix-permissions /usr/local/share/jupyter

#RUN jupyter toree install --sys-prefix --spark_opts="--master yarn --deploy-mode cluster" --interpreters=PySpark \
# && rm -rf /home/$NB_USER/.local \
# && fix-permissions $CONDA_DIR && \
#    fix-permissions /home/$NB_USER

#ENTRYPOINT ["jupyter", "notebook", "--no-browser", "--allow-root"]

USER root

# Install supervisor
RUN apt-get update \
 && apt-get install -y supervisor \
 && mkdir -p /var/log/supervisor

# Copy supervisor configuration
COPY conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN fix-permissions /var/log/supervisor/

CMD ["/usr/bin/supervisord"]

#USER $NB_USER
