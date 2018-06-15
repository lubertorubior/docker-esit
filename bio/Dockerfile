FROM taroull/spark:2.3.1 as spark
FROM broadinstitute/gatk:4.0.5.1

# Update and install some useful packages
RUN apt-get update && apt-get install -y curl

# Set hadoop and spark environment data
ENV HADOOP_VERSION 2.8.3
ENV HADOOP_PREFIX /opt/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR /etc/hadoop
ENV HADOOP_EXTRA_CLASSPATH /opt/lib/hadoop
ENV SPARK_VERSION 2.3.1
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

# Create directories for other genomic tools
ENV GENOMIC_TOOLS /genomics/tools
WORKDIR $GENOMIC_TOOLS

# Install BWA
ENV BWA_VERSION 0.7.17
ADD https://github.com/lh3/bwa/releases/download/v$BWA_VERSION/bwa-$BWA_VERSION.tar.bz2 /tmp/
RUN tar -xvjf /tmp/bwa-$BWA_VERSION.tar.bz2 \
 && rm /tmp/bwa-$BWA_VERSION.tar.bz2*
WORKDIR bwa-$BWA_VERSION
RUN make

WORKDIR $GENOMIC_TOOLS

# Install Cromwell
ENV CROMWELL_VERSION 32
RUN mkdir cromwell-$CROMWELL_VERSION
ADD https://github.com/broadinstitute/cromwell/releases/download/$CROMWELL_VERSION/cromwell-$CROMWELL_VERSION.jar cromwell-$CROMWELL_VERSION

# Install FastQC
ENV FASTQC_VERSION 0.11.7
ADD https://github.com/s-andrews/FastQC/archive/v$FASTQC_VERSION.tar.gz /tmp/
RUN tar -xzvf /tmp/v$FASTQC_VERSION.tar.gz \
 && rm /tmp/v$FASTQC_VERSION.tar.gz*

# Install Qualimap
ENV QUALIMAP_VERSION 2.2.1
ADD https://bitbucket.org/kokonech/qualimap/downloads/qualimap_v$QUALIMAP_VERSION.zip /tmp/
RUN unzip /tmp/qualimap_v$QUALIMAP_VERSION.zip \
 && rm /tmp/qualimap_v$QUALIMAP_VERSION.zip*

# Install Nextflow
ENV NEXTFLOW_VERSION 0.28.0
RUN mkdir nextflow-$NEXTFLOW_VERSION
ADD https://github.com/nextflow-io/nextflow/releases/download/v$NEXTFLOW_VERSION/nextflow-$NEXTFLOW_VERSION-all nextflow-$NEXTFLOW_VERSION

# Install Picard
ENV PICARD_VERSION 2.18.0
RUN mkdir picard-$PICARD_VERSION
ADD https://github.com/broadinstitute/picard/releases/download/$PICARD_VERSION/picard.jar picard-$PICARD_VERSION

# Install Rabix Executor
ENV RABIX_VERSION 1.0.4
ADD https://github.com/rabix/bunny/releases/download/v$RABIX_VERSION-5/rabix-$RABIX_VERSION.tar.gz /tmp/
RUN tar -xzvf /tmp/rabix-$RABIX_VERSION.tar.gz \
 && rm /tmp/rabix-$RABIX_VERSION.tar.gz*

# Create soft link to existing Samtools
RUN mkdir samtools-0.1.19 \
 && ln -s /usr/bin/samtools samtools-0.1.19/samtools

# Install Tabix
RUN apt-get install tabix \
 && mkdir tabix-1.2.1 \
 && ln -s /usr/bin/tabix tabix-1.2.1/tabix

# Install Wgsim
ENV WGSIM_VERSION 0.3.1
RUN git clone https://github.com/lh3/wgsim.git \
 && mv wgsim wgsim-$WGSIM_VERSION
WORKDIR $GENOMIC_TOOLS/wgsim-$WGSIM_VERSION
RUN gcc -g -O2 -Wall -o wgsim wgsim.c -lz -lm

WORKDIR $GENOMIC_TOOLS

# Install Womtool
ENV WOMTOOL_VERSION 31
RUN mkdir womtool-$WOMTOOL_VERSION
ADD https://github.com/broadinstitute/cromwell/releases/download/$WOMTOOL_VERSION/womtool-$WOMTOOL_VERSION.jar womtool-$WOMTOOL_VERSION

# Set permissions
RUN chmod +x bwa-$BWA_VERSION/bwa \
             cromwell-$CROMWELL_VERSION/cromwell-$CROMWELL_VERSION.jar \
             FastQC-$FASTQC_VERSION/fastqc \
             nextflow-$NEXTFLOW_VERSION/nextflow-$NEXTFLOW_VERSION-all \
             picard-$PICARD_VERSION/picard.jar \
             qualimap_v$QUALIMAP_VERSION/qualimap.jar \
             rabix-cli-$RABIX_VERSION/rabix \
             wgsim-$WGSIM_VERSION/wgsim \
             womtool-$WOMTOOL_VERSION/womtool-$WOMTOOL_VERSION.jar

# Set aliases for easier usage
RUN echo "alias bwa=$GENOMIC_TOOLS/bwa-$BWA_VERSION/bwa" >> ~/.bashrc \
 && echo 'alias cromwell="java -jar $GENOMIC_TOOLS/cromwell-$CROMWELL_VERSION/cromwell-$CROMWELL_VERSION.jar"' >> ~/.bashrc \
 && echo "alias fastqc=$GENOMIC_TOOLS/FastQC-$FASTQC_VERSION/fastqc" >> ~/.bashrc \
 && echo "alias nextflow=$GENOMIC_TOOLS/nextflow-$NEXTFLOW_VERSION/nextflow-$NEXTFLOW_VERSION-all" >> ~/.bashrc \
 && echo 'alias picard="java -jar $GENOMIC_TOOLS/picard-$PICARD_VERSION/picard.jar"' >> ~/.bashrc \
 && echo 'alias qualimap="$GENOMIC_TOOLS/qualimap_v$QUALIMAP_VERSION/qualimap"' >> ~/.bashrc \
 && echo "alias rabix=$GENOMIC_TOOLS/rabix-cli-$RABIX_VERSION/rabix" >> ~/.bashrc \
 && echo "alias wgsim=$GENOMIC_TOOLS/wgsim-$WGSIM_VERSION/wgsim" >> ~/.bashrc \
 && echo 'alias womtool="java -jar $GENOMIC_TOOLS/womtool-$WOMTOOL_VERSION/womtool-$WOMTOOL_VERSION.jar"' >> ~/.bashrc

# Create default directory
ENV DEFAULT_DIR /datos
RUN mkdir -p $DEFAULT_DIR
WORKDIR $DEFAULT_DIR

# Download tests
ADD https://raw.githubusercontent.com/lubertorubior/docker-esit/master/test/run_tests.sh /datos
RUN chmod +x /datos/run_tests.sh

# Set locale
RUN apt-get install -y locales \
 && echo "LC_ALL=en_US.UTF-8" >> /etc/environment \
 && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
 && echo "LANG=en_US.UTF-8" > /etc/locale.conf \
 && locale-gen en_US.UTF-8

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
RUN apt-get update \
 && apt-get install -y openssh-server supervisor \
 && mkdir -p /var/run/sshd /var/log/supervisor

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
