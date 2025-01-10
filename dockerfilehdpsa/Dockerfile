# Source jupyter/pyspark-notebook is under copyright (c) Jupyter Development Team
# and distributed under the terms of the Modified BSD License

FROM quay.io/jupyter/pyspark-notebook:spark-3.5.3

USER root

# =================================================================
# Utils

RUN apt update && apt install -y openssh-server && \
    apt install -y net-tools && apt install -y iproute2 && \
    apt install -y openjdk-8-jdk

# =================================================================
# Hadoop installation
# Based on https://github.com/Segence/docker-hadoop

RUN groupadd hadoop
RUN useradd -d /home/hadoop -g hadoop -m hadoop --shell /bin/bash
RUN groupadd hadoopusers
RUN usermod -a -G hadoopusers ${NB_USER}

# SSH without key
RUN mkdir /home/hadoop/.ssh
RUN ssh-keygen -t rsa -f /home/hadoop/.ssh/id_rsa -P '' && \
    cat /home/hadoop/.ssh/id_rsa.pub >> /home/hadoop/.ssh/authorized_keys

# Hadoop install
RUN wget https://mirrors.huaweicloud.com/apache/hadoop/common/hadoop-3.2.3/hadoop-3.2.3.tar.gz && \
    tar -xzvf hadoop-3.2.3.tar.gz -C /usr/local/ && \
    mv /usr/local/hadoop-3.2.3/ /usr/local/hadoop && \
    rm hadoop-3.2.3.tar.gz

# HBase install
RUN wget https://mirrors.huaweicloud.com/apache/hbase/2.5.4/hbase-2.5.4-bin.tar.gz && \
    tar -xzvf hbase-2.5.4-bin.tar.gz -C /usr/local/ && \
    mv /usr/local/hbase-2.5.4/ /usr/local/hbase/ && \
    rm hbase-2.5.4-bin.tar.gz

# Hive install
RUN wget https://mirrors.huaweicloud.com/apache/hive/hive-3.1.2/apache-hive-3.1.2-bin.tar.gz && \
    tar -xzvf apache-hive-3.1.2-bin.tar.gz -C /usr/local/ && \
    mv /usr/local/apache-hive-3.1.2-bin/ /usr/local/hive/ && \
    rm apache-hive-3.1.2-bin.tar.gz && rm -r /var/lib/apt/lists/*

# Fix libs mismatch
RUN rm /usr/local/hive/lib/log4j-slf4j-impl-2.10.0.jar && \
    rm /usr/local/hive/lib/guava-*.jar && \
    cp /usr/local/hadoop/share/hadoop/common/lib/guava-27.0-jre.jar /usr/local/hive/lib

# Environment variables
ENV HADOOP_HOME=/usr/local/hadoop
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV JAVA_HOME=/usr
ENV HBASE_HOME=/usr/local/hbase
ENV HBASE_CONF_DIR=/usr/local/hbase/conf
ENV HIVE_HOME=/usr/local/hive
ENV HIVE_CONF_DIR=/usr/local/hive/conf

# Spark environment variables
ENV LD_LIBRARY_PATH=$HADOOP_HOME/lib/native/:$LD_LIBRARY_PATH

# Configuring Hadoop classpath for Spark
RUN echo "export SPARK_DIST_CLASSPATH=$($HADOOP_HOME/bin/hadoop classpath)" > /usr/local/spark/conf/spark-env.sh

# Setting the PATH environment variable globally and for the Hadoop user
ENV PATH=$PATH:$JAVA_HOME/bin:/usr/local/hadoop/bin:/usr/local/hadoop/sbin:/usr/local/hbase/bin:/usr/local/hive/bin
RUN echo "PATH=$PATH:$JAVA_HOME/bin:/usr/local/hadoop/bin:/usr/local/hadoop/sbin:/usr/local/hbase/bin:/usr/local/hive/bin" >> /home/hadoop/.bashrc
RUN echo "export HADOOP_HOME=/usr/local/hadoop" >> /home/hadoop/.bashrc
RUN echo "export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop" >> /home/hadoop/.bashrc
RUN echo "export JAVA_HOME=/usr" >> /home/hadoop/.bashrc
RUN echo "export HBASE_HOME=/usr/local/hbase" >> /home/hadoop/.bashrc
RUN echo "export HBASE_CONF_DIR=/usr/local/hbase/conf" >> /home/hadoop/.bashrc
RUN echo "export HIVE_HOME=/usr/local/hive" >> /home/hadoop/.bashrc
RUN echo "export HIVE_CONF_DIR=/usr/local/hive/conf" >> /home/hadoop/.bashrc

# Hadoop configuration
COPY configs/sshd_config /etc/ssh/sshd_config
COPY configs/ssh_config /home/hadoop/.ssh/config
COPY configs/*.xml /usr/local/hadoop/etc/hadoop/
COPY configs/hadoop-env.sh /usr/local/hadoop/etc/hadoop/

# HBase configuration
COPY configshb/hbase-site.xml /usr/local/hbase/conf/
COPY configshb/hbase-env.sh /usr/local/hbase/conf/
COPY configshv/hive-site.xml /usr/local/hive/conf/

# Adding initialization scripts
RUN mkdir $HADOOP_HOME/bin/init
COPY scripts/start-hadoop.sh $HADOOP_HOME/bin/init/

# Creating data directories
RUN mkdir /home/hadoop/tmp
RUN mkdir -p /data/hdfs/namenode
RUN mkdir -p /data/hdfs/datanode
RUN mkdir -p /data/logs/hadoop
RUN mkdir -p /data/logs/hbase
RUN chown -R hadoop:hadoop /data
RUN mkdir /home/hadoop/zookeeper
RUN mkdir /usr/local/hivemetastore

# Setting up log directories
RUN ln -s /data/logs/hadoop $HADOOP_HOME/logs
RUN ln -s $HADOOP_HOME/logs /var/log/hadoop
RUN mkdir -p $HBASE_HOME/logs
RUN ln -s /data/logs/hbase $HBASE_HOME/logs

# Directories and permissions
RUN chown -R hadoop:hadoop /home/hadoop
RUN chown -R hadoop:hadoop $HADOOP_HOME
RUN chown -R hadoop:hadoop $HBASE_HOME
RUN chown -R hadoop:hadoop $HIVE_HOME
RUN chmod 777 /home/hadoop/tmp
RUN chmod 777 /data/logs/hadoop
RUN chmod 777 /data/logs/hbase
RUN chmod 777 /usr/local/hivemetastore

# (!) Danger zone (!)
RUN echo "jovyan ALL=(ALL)   ALL" >> /etc/sudoers
RUN echo "jovyan:redspot" | chpasswd

# =================================================================

USER $NB_UID

# Modules, packages and libraries
RUN pip install --no-cache-dir nbgitpuller

# Jupyter extensions
RUN pip install jupyter-server-proxy && \
    jupyter server extension enable --sys-prefix jupyter_server_proxy

# -= Future releases =-
# Elyra extension https://github.com/elyra-ai/elyra
# does not support JupyterLab >= 4.x
#RUN pip install --upgrade elyra-code-snippet-extension && \
#    pip install --upgrade elyra-python-editor-extension && \
#    jupyter server extension enable elyra