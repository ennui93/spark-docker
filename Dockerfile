FROM ubuntu:16.04

LABEL MAINTAINER Cristòfol Torrens Morell "piffall@gmail.com"
LABEL CONTRIBUTOR Vicenç Juan Tomàs Monserrat "vtomasr5@gmail.com"

LABEL STB_VERSION=1.1.0
LABEL SPARK_VERSION=2.2.1
LABEL HADOOP_VERSION=2.7

# Install required packages
RUN \
    apt-get update && \
    apt-get -y install software-properties-common && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
    add-apt-repository -y ppa:webupd8team/java && \
    apt-get install python python-pip python3 python3-pip && \
    add-apt-repository ppa:jonathonf/python-3.6 && \
    apt-get update && \
    apt-get install -y oracle-java8-installer wget python3.6 && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/oracle-jdk8-installer

WORKDIR /opt

# Install SBT
ENV SBT_VERSION 1.1.0
ENV SBT_HOME /opt/sbt
RUN \
    mkdir -p /opt && \
    wget https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz && \
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
    wget http://apache.rediris.es/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    tar vxzf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz --strip 1 -C ${SPARK_HOME} && \
    rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz

# Copy scripts
COPY start-master /usr/bin/start-master
COPY start-worker /usr/bin/start-worker
COPY start-driver /usr/bin/start-driver

# Add spark bin path to PATH
ENV PATH $PATH:${SPARK_HOME}/bin

# Set Java HOME
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

