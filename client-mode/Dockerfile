FROM ubuntu:latest

EXPOSE 8888
ENV PORT=8888

# Install Spark - code modified from https://github.com/jupyter/docker-stacks/blob/master/pyspark-notebook/Dockerfile
# Spark dependencies
# Default values can be overridden at build time
# (ARGS are in lower case to distinguish them from ENV)
ARG spark_version="3.1.1"
ARG hadoop_version="3.2"
ARG spark_checksum="E90B31E58F6D95A42900BA4D288261D71F6C19FA39C1CB71862B792D1B5564941A320227F6AB0E09D946F16B8C1969ED2DEA2A369EC8F9D2D7099189234DE1BE"
ARG openjdk_version="14"
ARG NB_UID="1000"
ARG NB_USER="joyvan"


ENV APACHE_SPARK_VERSION="${spark_version}" \
    HADOOP_VERSION="${hadoop_version}" \
    HADOOP_MAJOR_VERSION="3"



RUN apt-get -y update && \
    apt-get install --no-install-recommends -y \
    curl \
    tini \
    wget \
    python \
    python3-pip \
    "openjdk-${openjdk_version}-jre-headless" \
    ca-certificates-java && \
    apt-get clean && rm -rf /var/lib/apt/lists/* 

# Spark installation
WORKDIR /tmp
# Using the preferred mirror to download Spark
# hadolint ignore=SC2046
RUN wget -q $(wget -qO- https://www.apache.org/dyn/closer.lua/spark/spark-${APACHE_SPARK_VERSION}/spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz\?as_json | \
    python3 -c "import sys, json; content=json.load(sys.stdin); print(content['preferred']+content['path_info'])") && \
    echo "${spark_checksum} *spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz" | sha512sum -c - && \
    tar xzf "spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz" -C /opt --owner root --group root --no-same-owner && \
    mv /opt/spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} /opt/spark && \
    rm "spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz"

# Configure Spark
ENV SPARK_HOME=/opt/spark \
    PATH=$PATH:$SPARK_HOME/bin \
    PATH=$PATH:/home/${NB_USER}/.local/bin \
    PYSPARK_PYTHON=python3

RUN echo "alias pyspark=/opt/spark/bin/pyspark" >> ~/.bashrc && \
    echo "alias spark-shell=/opt/spark/bin/spark-shell" >> ~/.bashrc

# Create NB_USER with name jovyan user with UID=1000 and in the 'users' group
# and make sure these dirs are writable by the `users` group.
RUN useradd -l -m -s /bin/bash -N -u $NB_UID $NB_USER && \
    chmod g+w /etc/passwd

# Add Google Cloud Storage and BigQuery Connectivity
WORKDIR $SPARK_HOME/conf
ARG GCS_CONNECTOR_VERSION=2.2.0
ADD https://storage.googleapis.com/hadoop-lib/gcs/gcs-connector-hadoop${HADOOP_MAJOR_VERSION}-${GCS_CONNECTOR_VERSION}.jar $SPARK_HOME/jars
RUN chmod 644 $SPARK_HOME/jars/gcs-connector-hadoop${HADOOP_MAJOR_VERSION}-${GCS_CONNECTOR_VERSION}.jar
ADD https://storage.googleapis.com/spark-lib/bigquery/spark-bigquery-with-dependencies_2.12-0.20.0.jar $SPARK_HOME/jars
RUN chmod 644 $SPARK_HOME/jars/spark-bigquery-with-dependencies_2.12-0.20.0.jar

ARG key_file_path="/home/data/sa.json"
ENV GOOGLE_APPLICATION_CREDENTIALS=${key_file_path}
RUN cp $SPARK_HOME/conf/spark-defaults.conf.template $SPARK_HOME/conf/spark-defaults.conf && \
    echo spark.hadoop.google.cloud.auth.service.account.enable       true >> spark-defaults.conf && \ 
    echo spark.hadoop.google.cloud.auth.service.account.json.keyfile        ${key_file_path}>> spark-defaults.conf && \
    echo spark.hadoop.fs.gs.AbstractFilePath.impl     com.google.cloud.hadoop.fs.gcs.GoogleHadoopFS >> spark-defaults.conf


USER $NB_UID
# Install Required Python Packages
COPY requirements.txt requirements.txt
RUN \
    pip3 install --upgrade pip && \
    pip3 install -r requirements.txt && \
    jupyter notebook --generate-config && \
    jupyter lab clean

# Define working directory
WORKDIR /home/data
COPY load_files/ load_files/
# Define default command
# Configure container startup
ENTRYPOINT ["tini", "-g", "--"]
CMD jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --NotebookApp.token=
