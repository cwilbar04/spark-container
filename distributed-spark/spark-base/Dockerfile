FROM base

ARG spark_version="3.1.1"
ARG hadoop_version="3.2"
ARG hadoop_major_version="3"

# Spark installation

WORKDIR /tmp

RUN curl https://archive.apache.org/dist/spark/spark-${spark_version}/spark-${spark_version}-bin-hadoop${hadoop_version}.tgz -o spark.tgz && \
    tar -xf spark.tgz -C /opt --owner root --group root --no-same-owner && \
    mv /opt/spark-${spark_version}-bin-hadoop${hadoop_version} /opt/spark && \
    rm "spark.tgz" && \
    echo "alias pyspark=/opt/spark/bin/pyspark" >> ~/.bashrc && \
    echo "alias spark-shell=/opt/spark/bin/spark-shell" >> ~/.bashrc && \
    mkdir /opt/spark/logs

# Configure Environment
ENV SPARK_HOME=/opt/spark 
ENV PATH=$PATH:$SPARK_HOME/bin 
ENV PYSPARK_PYTHON=python3
ENV SPARK_MASTER_HOST=spark-master
ENV SPARK_MASTER_PORT=7077

# Add Google Cloud Storage and BigQuery Connectivity
WORKDIR $SPARK_HOME/conf
ARG gcs_conncetor_version=2.2.0
ADD https://storage.googleapis.com/hadoop-lib/gcs/gcs-connector-hadoop${hadoop_major_version}-${gcs_conncetor_version}.jar $SPARK_HOME/jars
RUN chmod 644 $SPARK_HOME/jars/gcs-connector-hadoop${hadoop_major_version}-${gcs_conncetor_version}.jar
ADD https://storage.googleapis.com/spark-lib/bigquery/spark-bigquery-with-dependencies_2.12-0.20.0.jar $SPARK_HOME/jars
RUN chmod 644 $SPARK_HOME/jars/spark-bigquery-with-dependencies_2.12-0.20.0.jar

ARG key_file_path="${SHARED_WORKSPACE}/sa.json"
ENV GOOGLE_APPLICATION_CREDENTIALS=${key_file_path}
RUN cp $SPARK_HOME/conf/spark-defaults.conf.template $SPARK_HOME/conf/spark-defaults.conf && \
    echo spark.hadoop.google.cloud.auth.service.account.enable       true >> spark-defaults.conf && \ 
    echo spark.hadoop.google.cloud.auth.service.account.json.keyfile        ${key_file_path}>> spark-defaults.conf && \
    echo spark.hadoop.fs.gs.AbstractFilePath.impl     com.google.cloud.hadoop.fs.gcs.GoogleHadoopFS >> spark-defaults.conf


WORKDIR ${SPARK_HOME}