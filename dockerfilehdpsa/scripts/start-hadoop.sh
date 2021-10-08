#!/bin/bash

# Based on https://github.com/Segence/docker-hadoop
# by Rob Vadai https://twitter.com/robvadai

# Restarting HDFS has to be done after formatting the namenode,
# otherwise running the first MapReduce job will always fail
# and the cluster will terminate

#HADOOP_NAMENODE_HOST=$(hostname --fqdn)
HADOOP_NAMENODE_HOST=0.0.0.0
#HADOOP_CURRENT_HOST=$(hostname --fqdn)
HADOOP_CURRENT_HOST=0.0.0.0

sed -i -e 's/HADOOP_NAMENODE_HOST/'"$HADOOP_NAMENODE_HOST"'/g' $HADOOP_CONF_DIR/core-site.xml
sed -i -e 's/HADOOP_NAMENODE_HOST/'"$HADOOP_NAMENODE_HOST"'/g' $HADOOP_CONF_DIR/yarn-site.xml
sed -i -e 's/HADOOP_CURRENT_HOST/'"$HADOOP_CURRENT_HOST"'/g' $HADOOP_CONF_DIR/yarn-site.xml

echo -e "\n***************** FORMATTING NAMENODE **********************\n"
hdfs namenode -format

echo -e "\n******************** STARTING HDFS *************************\n"
$HADOOP_HOME/sbin/start-dfs.sh

echo -e "\n******************** STARTING YARN *************************\n"
$HADOOP_HOME/sbin/start-yarn.sh

echo -e "\n*************** STARTING MAPREDUCE HISTORY SERVER **********\n"
$HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver

echo -e "\n***************** HDFS CLUSTER OVERVIEW ********************\n"
$HADOOP_HOME/bin/hdfs dfsadmin -report
