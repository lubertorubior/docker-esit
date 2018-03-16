FROM taroull/spark:2.3.0 as spark
FROM broadinstitute/gatk:4.0.2.1

# Update and install some useful packages
RUN apt-get update && apt-get install -y curl

# Set hadoop and spark environment data
ENV HADOOP_VERSION 2.8.3
ENV HADOOP_PREFIX /opt/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR /etc/hadoop
ENV HADOOP_EXTRA_CLASSPATH /opt/lib/hadoop
ENV SPARK_VERSION 2.3.0
ENV SPARK_HOME /opt/spark-$SPARK_VERSION
ENV SPARK_CONF_DIR /etc/spark
ENV SPARK_EXTRA_CLASSPATH /opt/lib/spark

# Copy hadoop data from spark image
COPY --from=spark $HADOOP_PREFIX $HADOOP_PREFIX
RUN ln -s $HADOOP_PREFIX/etc/hadoop $HADOOP_CONF_DIR

# Copy spark data from spark image
COPY --from=spark $SPARK_HOME $SPARK_HOME
RUN ln -s $SPARK_HOME/conf $SPARK_CONF_DIR

# Add hadoop and spark to path
ENV PATH $SPARK_HOME/bin:$HADOOP_PREFIX/bin:$PATH
ENV HADOOP_CLASSPATH $HADOOP_EXTRA_CLASSPATH

# Patch gatk script to include our custom classpath first
RUN sed -i /spark.driver.userClassPathFirst/s/^/#/ /gatk/gatk

# Create work directory
RUN mkdir -p /datos
WORKDIR /datos

ADD https://raw.githubusercontent.com/lubertorubior/docker-esit/master/run_tests.sh /datos
RUN chmod +x /datos/run_tests.sh

# Set locale
RUN apt-get install -y locales
RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN echo "LANG=en_US.UTF-8" > /etc/locale.conf
RUN locale-gen en_US.UTF-8

# Install some nice packages
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get install -y --fix-missing \
  curl \
  htop \
  memstat \
  nano \
  netcat \
  net-tools \
  sysstat \
  tmux \
  unzip \
  wget \
  xmlstarlet

# Install ssh server
RUN apt-get update && apt-get install -y openssh-server supervisor
RUN mkdir -p /var/run/sshd /var/log/supervisor

# TODO ESTO ES SIN COPIAR sshd_config
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Copy configuration files
#COPY conf/sshd_config /etc/ssh/sshd_config
COPY conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# SSH
EXPOSE 22

# Copy entrypoint scripts
COPY --from=spark /entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
COPY ./docker-entrypoint.d/* /docker-entrypoint.d/
COPY --from=spark /docker-entrypoint.d/ /docker-entrypoint.d/
RUN chmod +x /docker-entrypoint.d/*
#CMD ["/usr/bin/supervisord"]
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord"]
