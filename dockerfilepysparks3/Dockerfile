# Source jupyter/pyspark-notebook is under copyright (c) Jupyter Development Team
# and distributed under the terms of the Modified BSD License

FROM quay.io/jupyter/pyspark-notebook:spark-3.5.3

USER root

# JAR files for Spark S3 access
# Documentstion https://hadoop.apache.org/docs/r3.3.1/hadoop-aws/tools/hadoop-aws/troubleshooting_s3a.html
# Maven repos https://mvnrepository.com/artifact/org.apache.hadoop/hadoop-aws
# and https://mvnrepository.com/artifact/com.amazonaws/aws-java-sdk-bundle
# Each Hadoop version should match aws-java-sdk-XXX.jar, hadoop-aws-XXX.jar
RUN wget https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.11.375/aws-java-sdk-bundle-1.11.375.jar && \
    wget https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.2.3/hadoop-aws-3.2.3.jar && \
    wget https://jdbc.postgresql.org/download/postgresql-42.3.1.jar && \
    mv *.jar /usr/local/spark/jars/

USER $NB_UID

# Modules, packages and libraries
RUN pip install --no-cache-dir boto3 s3fs psycopg2-binary nbgitpuller

# Jupyter extensions
RUN pip install jupyter-server-proxy && \
    jupyter server extension enable --sys-prefix jupyter_server_proxy

# -= Future releases =-
# Elyra extension https://github.com/elyra-ai/elyra
# does not support JupyterLab >= 4.x
#RUN pip install --upgrade elyra-code-snippet-extension && \
#    pip install --upgrade elyra-python-editor-extension && \
#    jupyter server extension enable elyra