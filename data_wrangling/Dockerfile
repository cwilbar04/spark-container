FROM ubuntu:latest

EXPOSE 8888
# # Install OpenJDK 8
# RUN \
#     apt-get update && \
#     apt-get install -y openjdk-11-jdk && \
#     rm -rf /var/lib/apt/lists/*
# USER root

# Install Python
RUN \
    apt-get update && \
    apt-get install -y python3.8 python3-pip curl && \
    rm -rf /var/lib/apt/lists/*



# Install Spark - code modified from https://github.com/jupyter/docker-stacks/blob/master/pyspark-notebook/Dockerfile
# Spark dependencies
# Default values can be overridden at build time
# (ARGS are in lower case to distinguish them from ENV)
ARG spark_version="3.1.1"
ARG hadoop_version="3.2"
ARG spark_checksum="E90B31E58F6D95A42900BA4D288261D71F6C19FA39C1CB71862B792D1B5564941A320227F6AB0E09D946F16B8C1969ED2DEA2A369EC8F9D2D7099189234DE1BE"
ARG openjdk_version="14"

ENV APACHE_SPARK_VERSION="${spark_version}" \
    HADOOP_VERSION="${hadoop_version}" \
    HADOOP_MAJOR_VERSION="3"


RUN apt-get -y update && \
    apt-get install --no-install-recommends -y \
    tini \
    wget \
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
    PYSPARK_PYTHON=python3

# # HADOOP

# ENV HADOOP_HOME /usr/hadoop-$HADOOP_VERSION
# ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
# ENV PATH $PATH:$HADOOP_HOME/bin
# RUN curl -sL --retry 3 \
#     "http://archive.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz" \
#     | gunzip \
#     | tar -x -C /usr/ && \
#     rm -rf $HADOOP_HOME/share/doc



WORKDIR /tmp
# Install Required Python Packages
COPY requirements.txt requirements.txt
RUN \
    pip3 install --upgrade pip && \
    pip3 install -r requirements.txt


# Create user so not executing as root
ARG user_id='pitfox'
RUN useradd -ms /bin/bash $user_id
USER $user_id
WORKDIR /home/$user_id
RUN mkdir data

USER root
# Add Google Cloud Storage and BigQuery Connectivity
WORKDIR $SPARK_HOME/conf
ARG GCS_CONNECTOR_VERSION=2.2.0
ADD https://storage.googleapis.com/hadoop-lib/gcs/gcs-connector-hadoop${HADOOP_MAJOR_VERSION}-${GCS_CONNECTOR_VERSION}.jar $SPARK_HOME/jars
RUN chmod 644 $SPARK_HOME/jars/gcs-connector-hadoop${HADOOP_MAJOR_VERSION}-${GCS_CONNECTOR_VERSION}.jar
ADD https://storage.googleapis.com/spark-lib/bigquery/spark-bigquery-with-dependencies_2.12-0.20.0.jar $SPARK_HOME/jars
RUN chmod 644 $SPARK_HOME/jars/spark-bigquery-with-dependencies_2.12-0.20.0.jar

ARG key_file_path="/home/pitfox/data/spark-container-dev-f5d53ab2439c.json"
ENV GOOGLE_APPLICATION_CREDENTIALS=${key_file_path}
RUN cp $SPARK_HOME/conf/spark-defaults.conf.template $SPARK_HOME/conf/spark-defaults.conf && \
    echo spark.hadoop.google.cloud.auth.service.account.enable       true >> spark-defaults.conf && \ 
    echo spark.hadoop.google.cloud.auth.service.account.json.keyfile        ${key_file_path}>> spark-defaults.conf && \
    echo spark.hadoop.fs.gs.AbstractFilePath.impl     com.google.cloud.hadoop.fs.gcs.GoogleHadoopFS >> spark-defaults.conf


USER $USER_ID
# Define working directory
WORKDIR /home/$user_id/data

# Define default command
# Configure container startup
ENTRYPOINT ["tini", "-g", "--"]
CMD ["bash"]