FROM vgarshin/mibapysparks3:20211002v1

USER root

# =================================================================
# Utils

RUN apt update && apt install -y openssh-server && \
    apt install -y net-tools && apt install -y iproute2 && \
    apt install -y openjdk-8-jdk

# =================================================================
# Hadoop installation
# Based on https://github.com/Segence/docker-hadoop
# by Rob Vadai https://twitter.com/robvadai

RUN groupadd hadoop
RUN useradd -d /home/hadoop -g hadoop -m hadoop --shell /bin/bash
RUN groupadd hadoopusers
RUN useradd -g hadoopusers ${NB_UID}

# SSH without key
RUN mkdir /home/hadoop/.ssh
RUN ssh-keygen -t rsa -f /home/hadoop/.ssh/id_rsa -P '' && \
    cat /home/hadoop/.ssh/id_rsa.pub >> /home/hadoop/.ssh/authorized_keys

# Installing Hadoop
RUN wget http://apache.mirror.anlx.net/hadoop/common/hadoop-3.2.2/hadoop-3.2.2.tar.gz && \
    tar -xzvf hadoop-3.2.2.tar.gz -C /usr/local/ && \
    mv /usr/local/hadoop-3.2.2/ /usr/local/hadoop && \
    rm hadoop-3.2.2.tar.gz && rm -r /var/lib/apt/lists/*

# Environment variables
ENV HADOOP_HOME=/usr/local/hadoop
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV JAVA_HOME=/usr

# Spark environment variables
ENV LD_LIBRARY_PATH=$HADOOP_HOME/lib/native/:$LD_LIBRARY_PATH

# Configuring Hadoop classpath for Spark
RUN echo "export SPARK_DIST_CLASSPATH=$($HADOOP_HOME/bin/hadoop classpath)" > /usr/local/spark/conf/spark-env.sh

# Setting the PATH environment variable globally and for the Hadoop user
ENV PATH=$PATH:$JAVA_HOME/bin:/usr/local/hadoop/bin:/usr/local/hadoop/sbin
RUN echo "PATH=$PATH:$JAVA_HOME/bin:/usr/local/hadoop/bin:/usr/local/hadoop/sbin" >> /home/hadoop/.bashrc
RUN echo "export HADOOP_HOME=/usr/local/hadoop" >> /home/hadoop/.bashrc
RUN echo "export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop" >> /home/hadoop/.bashrc
RUN echo "export JAVA_HOME=/usr" >> /home/hadoop/.bashrc

# Hadoop configuration
COPY configs/sshd_config /etc/ssh/sshd_config
COPY configs/ssh_config /home/hadoop/.ssh/config
COPY configs/*.xml /usr/local/hadoop/etc/hadoop/
COPY configs/hadoop-env.sh /usr/local/hadoop/etc/hadoop/

# Adding initialisation scripts
RUN mkdir $HADOOP_HOME/bin/init
COPY scripts/start-hadoop.sh $HADOOP_HOME/bin/init/

# Creating data directories
RUN mkdir /home/hadoop/tmp
RUN mkdir -p /data/hdfs/namenode
RUN mkdir -p /data/hdfs/datanode
RUN mkdir -p /data/logs/hadoop
RUN chown -R hadoop:hadoop /data

# Setting up log directories
RUN ln -s /data/logs/hadoop $HADOOP_HOME/logs
RUN ln -s $HADOOP_HOME/logs /var/log/hadoop

# Dirs and permissions
RUN chown -R hadoop:hadoop /home/hadoop
RUN chown -R hadoop:hadoop $HADOOP_HOME
RUN chmod 777 /home/hadoop/tmp
RUN chmod 777 /data/logs/hadoop

# Danger zone redspotted!!!
RUN echo "jovyan ALL=(ALL)   ALL" >> /etc/sudoers
RUN echo "jovyan:redspot" | chpasswd

# =================================================================

USER ${NB_UID}
