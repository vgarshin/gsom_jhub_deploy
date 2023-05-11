FROM jupyter/pyspark-notebook:spark-3.2.0

# proxy for spark ui and etc
RUN pip install jupyter-server-proxy && \
    jupyter serverextension enable --sys-prefix jupyter_server_proxy

USER root

# install old java for s3 access
RUN sudo apt-get update && sudo apt-get install libxtst6 && \
    wget https://cdn.azul.com/zulu/bin/zulu8.27.0.7-jdk8.0.162-linux_amd64.deb && \
    apt install ./zulu8.27.0.7-jdk8.0.162-linux_amd64.deb && \
    rm zulu8.27.0.7-jdk8.0.162-linux_amd64.deb

# jar files for spark s3 access
RUN wget https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.11.874/aws-java-sdk-bundle-1.11.874.jar && \
    wget https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.2.0/hadoop-aws-3.2.0.jar && \
    wget https://jdbc.postgresql.org/download/postgresql-42.3.1.jar && \
    mv *.jar /usr/local/spark/jars/

USER $NB_UID

RUN pip install pyspark==3.2.0 boto3 s3fs psycopg2-binary
