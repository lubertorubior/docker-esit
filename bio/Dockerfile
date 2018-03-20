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

# Create directories for other genomic tools
ENV GENOMIC_TOOLS /genomics/tools
RUN mkdir -p $GENOMIC_TOOLS/bwa \
             $GENOMIC_TOOLS/cromwell \
             $GENOMIC_TOOLS/nextflow \
             $GENOMIC_TOOLS/picard \
             $GENOMIC_TOOLS/rabix \
             $GENOMIC_TOOLS/samtools \
             $GENOMIC_TOOLS/wgsim \
             $GENOMIC_TOOLS/womtool

# Install BWA
ADD https://github.com/lh3/bwa/releases/download/v0.7.17/bwa-0.7.17.tar.bz2 /tmp/
RUN tar -xvjf /tmp/bwa-0.7.17.tar.bz2 -C $GENOMIC_TOOLS/bwa \
 && rm /tmp/bwa-0.7.17.tar.bz2*
WORKDIR $GENOMIC_TOOLS/bwa/bwa-0.7.17
RUN make
WORKDIR $GENOMIC_TOOLS

# Install Cromwell
ADD https://github.com/broadinstitute/cromwell/releases/download/31/cromwell-31.jar $GENOMIC_TOOLS/cromwell

# Install Nextflow
ADD https://github.com/nextflow-io/nextflow/releases/download/v0.28.0/nextflow-0.28.0-all $GENOMIC_TOOLS/nextflow

# Install Picard
ADD https://github.com/broadinstitute/picard/releases/download/2.18.0/picard.jar $GENOMIC_TOOLS/picard

# Install Rabix Executor
ADD https://github.com/rabix/bunny/releases/download/v1.0.4-5/rabix-1.0.4.tar.gz /tmp/
RUN tar -xzvf /tmp/rabix-1.0.4.tar.gz -C $GENOMIC_TOOLS/rabix/ \
 && rm /tmp/rabix-1.0.4.tar.gz*

# Create soft link to existing Samtools
RUN ln -s /usr/bin/samtools $GENOMIC_TOOLS/samtools/samtools

# Install Wgsim
RUN git clone https://github.com/lh3/wgsim.git
WORKDIR $GENOMIC_TOOLS/wgsim
RUN gcc -g -O2 -Wall -o wgsim wgsim.c -lz -lm
WORKDIR $GENOMIC_TOOLS

# Install Womtool
ADD https://github.com/broadinstitute/cromwell/releases/download/31/womtool-31.jar $GENOMIC_TOOLS/womtool

# Set permissions
RUN chmod +x bwa/bwa-0.7.17/bwa \
             cromwell/cromwell-31.jar \
             nextflow/nextflow-0.28.0-all \
             picard/picard.jar \
             rabix/rabix-cli-1.0.4/rabix \
             wgsim/wgsim \
             womtool/womtool-31.jar

# Set aliases for easier usage
ENV CROMWELL $GENOMIC_TOOLS/cromwell/cromwell-31.jar
ENV PICARD $GENOMIC_TOOLS/picard/picard.jar
ENV WOMTOOL $GENOMIC_TOOLS/womtool/womtool-31.jar
RUN echo "alias bwa=$GENOMIC_TOOLS/bwa/bwa-0.7.17/bwa" >> ~/.bashrc \
 && echo 'alias cromwell="java -jar $CROMWELL"' >> ~/.bashrc \
 && echo "alias nextflow=$GENOMIC_TOOLS/nextflow/nextflow-0.28.0-all" >> ~/.bashrc \
 && echo 'alias picard="java -jar $PICARD"' >> ~/.bashrc \
 && echo "alias rabix=$GENOMIC_TOOLS/rabix/rabix-cli-1.0.4/rabix" >> ~/.bashrc \
 && echo "alias wgsim=$GENOMIC_TOOLS/wgsim/wgsim" >> ~/.bashrc \
 && echo 'alias womtool="java -jar $WOMTOOL"' >> ~/.bashrc

# Create default directory
ENV DEFAULT_DIR /datos
RUN mkdir -p $DEFAULT_DIR
WORKDIR $DEFAULT_DIR

# Download tests
ADD https://raw.githubusercontent.com/lubertorubior/docker-esit/master/test/run_tests.sh /datos
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

# Install SSH server and supervisor
RUN apt-get update && apt-get install -y openssh-server supervisor
RUN mkdir -p /var/run/sshd /var/log/supervisor

# Set SSH configuration
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Dump env variables to profile.d so they are available through SSH
RUN printenv | grep -vE '^(HOME|USER|GROUP|UID|GID|SHELL|CONDA_MD5)' | sed 's/^/export /' > /etc/profile.d/env_vars.sh

# Fix for SSH
RUN echo "if [ -d \"$DEFAULT_DIR\" ]; then" > /etc/bash.bashrc \
 && echo "cd \"$DEFAULT_DIR\"" >> /etc/bash.bashrc \
 && echo "fi" >> /etc/bash.bashrc

# Copy supervisor configuration
COPY conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# SSH
EXPOSE 22

# Copy entrypoint scripts
COPY --from=spark /entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
COPY ./docker-entrypoint.d/* /docker-entrypoint.d/
COPY --from=spark /docker-entrypoint.d/ /docker-entrypoint.d/
RUN chmod +x /docker-entrypoint.d/*
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord"]
