# Source jupyter/minimal-notebook is under copyright (c) Jupyter Development Team
# and distributed under the terms of the Modified BSD License

FROM quay.io/jupyter/minimal-notebook:python-3.12.7

USER root

# PostgreSQL install
RUN apt update && apt install -y gnupg curl ca-certificates \
    libpq-dev libswt-gtk-4-jni libcurl4 openssl liblzma5 postgresql

# MongoBD install
RUN wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu2204-6.0.4.tgz && \
    tar -zxvf mongodb-linux-*-6.0.4.tgz && rm mongodb-linux-*-6.0.4.tgz && \
    mv mongodb-linux-x86_64-ubuntu2204-6.0.4/bin/* /usr/local/bin/

# MongoDB shell client ibstall
RUN wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | apt-key add - && \
    echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/6.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-6.0.list && \
    apt update && apt -y install mongodb-mongosh

# ClickHouse local https://clickhouse.com/docs/en/install#quick-install
# and SQLite install
RUN apt install sqlite3 -y && \
    curl https://clickhouse.com/ | sh && ./clickhouse install && rm clickhouse

# Working directories for PostgreSQL
RUN chown -R postgres:postgres /var/run/postgresql

#  Working directories for MongoBD data and logs
RUN mkdir -p /var/lib/mongo
RUN chown -R jovyan:users /var/lib/mongo
RUN mkdir -p /var/log/mongodb
RUN chown -R jovyan:users /var/log/mongodb

# Airflow config and start script with dbase
RUN mkdir /usr/local/etc/airflow
COPY configs/airflow.cfg /usr/local/etc/airflow
COPY scripts/start-airflow.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start-airflow.sh

# User's permissions
RUN echo "jovyan ALL=(ALL)   ALL" >> /etc/sudoers
RUN echo "jovyan:redspot" | chpasswd

# Databases create for user and Airflow
USER postgres

RUN service postgresql restart && \
    createuser --superuser ${NB_USER} && \
    createdb ${NB_USER} ${NB_USER}

RUN service postgresql restart && \
    createuser airflow && \
    createdb airflow_metadata -O airflow

USER $NB_UID

# Upload demo database from https://postgrespro.com/education/demodb
# Uncomment code below if needed
#RUN wget https://edu.postgrespro.com/demo-small-en.zip && \
#    unzip demo-small-en.zip && \
#    echo redspot | sudo -S service postgresql restart && \
#    psql -a -f  demo-small-en-20170815.sql

RUN pip install --upgrade pip

# Airflow install
RUN pip install --no-cache-dir "apache-airflow[celery]==2.10.4" \
    --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-2.10.4/constraints-3.8.txt"

# Modules, packages and libraries
RUN pip install --no-cache-dir sqlalchemy==1.4.54 psycopg2-binary ipython-sql \
    pymongo nbgitpuller

# Jupyter extensions
RUN pip install jupyter-server-proxy && \
    jupyter server extension enable --sys-prefix jupyter_server_proxy

# -= Future releases =-
# Elyra extension https://github.com/elyra-ai/elyra
# does not support JupyterLab >= 4.x
#RUN pip install --upgrade elyra-code-snippet-extension && \
#    pip install --upgrade elyra-python-editor-extension && \
#    jupyter server extension enable elyra