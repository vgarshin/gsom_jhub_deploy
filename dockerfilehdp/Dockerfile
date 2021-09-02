FROM jupyter/minimal-notebook:latest

USER root

# Copy distribs to install and config files
COPY hadoop-3.1.1.tar.gz .

COPY jdk-8u202-linux-x64.tar.gz .

RUN mkdir /etc/hadoop/

COPY hadoop/* /etc/hadoop/

# Hadoop install
RUN tar xzf hadoop-3.1.1.tar.gz && \
    mkdir -p /usr/hdp/3.1.4.0-315/hadoop/ && mv hadoop-3.1.1/* /usr/hdp/3.1.4.0-315/hadoop/ && \
    tar xzf jdk-8u202-linux-x64.tar.gz && \
    mkdir -p /usr/lib/jvm && mv jdk1.8.0_202/ /usr/lib/jvm && \
    update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk1.8.0_202/bin/java" 1 && \
    mkdir /usr/java && cd /usr/java/ && ln -s /usr/lib/jvm/jdk1.8.0_202/ oracle-jdk && \
    cd /etc/hadoop && for F in `ls -1`; do sed -i 's/novalocal/mcs.local/g' $F; done

# Clean and setup environment
RUN cd ~ && rm hadoop-3.1.1.tar.gz && rm jdk-8u202-linux-x64.tar.gz && rm -rf hadoop-3.1.1/

ENV PATH="${PATH}:/usr/hdp/3.1.4.0-315/hadoop/bin" 

ENV JAVA_HOME=/usr/java/oracle-jdk

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_UID
