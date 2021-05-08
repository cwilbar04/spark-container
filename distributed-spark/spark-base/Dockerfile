FROM base

ARG spark_version="3.1.1"
ARG hadoop_version="3.2"


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



WORKDIR ${SPARK_HOME}