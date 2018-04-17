FROM alpine:3.7

LABEL maintainer="github@seaofdirac.net"

# Install required packages
RUN \
    apk update && \
    apk add openjdk8 wget bash tar gzip dcron

WORKDIR /opt

# Install SBT
ENV SBT_VERSION 1.1.4
ENV SBT_HOME /opt/sbt
RUN \
    mkdir -p /opt && \
    wget "https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz" && \
    printf "2fbd592b1cfd7bc3612154a32925d5843b602490e8c8977a53fa86b35e308341 sbt-${SBT_VERSION}.tgz\n" | sha256sum -c - && \
    tar -zvxf sbt-${SBT_VERSION}.tgz -C /opt && \
    rm sbt-${SBT_VERSION}.tgz

# Add sbt bin path to PATH
ENV PATH $PATH:${SBT_HOME}/bin

# Install Spark
ENV SPARK_VERSION 2.2.1
ENV HADOOP_VERSION 2.7
ENV SPARK_HOME /usr/spark-${SPARK_VERSION}
RUN \
    mkdir ${SPARK_HOME} && \
    wget http://d3kbcqa49mib13.cloudfront.net/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    printf "79fb8285546670923a66082324bf56e99a7201476a52dea908804ddfa04f16c8 spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz\n" | sha256sum -c - && \
    tar vxzf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz --strip 1 -C ${SPARK_HOME} && \
    rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz

# Copy scripts
COPY start-master /usr/bin/start-master
COPY start-worker /usr/bin/start-worker
COPY start-driver /usr/bin/start-driver

# Add spark bin path to PATH
ENV PATH $PATH:${SPARK_HOME}/bin

# Set Java HOME
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk

