FROM jupyter/pyspark-notebook:latest

# proxy for spark ui and etc
RUN pip install jupyter-server-proxy && \
    jupyter serverextension enable --sys-prefix jupyter_server_proxy

USER root

# install old java for s3 access
RUN wget https://cdn.azul.com/zulu/bin/zulu8.27.0.7-jdk8.0.162-linux_amd64.deb && \
    apt install ./zulu8.27.0.7-jdk8.0.162-linux_amd64.deb && \
    rm zulu8.27.0.7-jdk8.0.162-linux_amd64.deb

# jar files for spark s3 access
RUN wget https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk/1.7.4/aws-java-sdk-1.7.4.jar && \
    wget https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/2.7.4/hadoop-aws-2.7.4.jar && \
    cp aws-java-sdk-1.7.4.jar /usr/local/spark/jars/ && \
    cp hadoop-aws-2.7.4.jar /usr/local/spark/jars/ && \
    rm aws-java-sdk-1.7.4.jar && \
    rm hadoop-aws-2.7.4.jar

# install s3fs to allow mounting an S3 bucket via FUSE
#RUN apt update && apt install s3fs -y

USER $NB_UID

RUN pip install pyspark boto3 s3fs
