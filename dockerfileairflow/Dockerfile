# https://github.com/jupyter/docker-stacks/blob/master/minimal-notebook/Dockerfile
# Source jupyter/minimal-notebook is under copyright (c) Jupyter Development Team.
# and distributed under the terms of the Modified BSD License.

FROM jupyter/minimal-notebook:2021-09-06

# This dockerfile is based on an original Dockerfile by Daniel Chudnov <dchud@umich.edu>
# https://github.com/dchud/datamanagement-notebook/blob/master/Dockerfile
# and by Tony Hirst
# https://github.com/psychemedia/jupyter-postgres-demo/blob/sudoers/Dockerfile

USER root

RUN apt-get update && apt-get install -y gnupg && \
    sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list' && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add - && \
    apt-get -y install postgresql && apt install libpq-dev

RUN chown -R postgres:postgres /var/run/postgresql
RUN echo "jovyan ALL=(ALL)   ALL" >> /etc/sudoers
RUN echo "jovyan:redspot" | chpasswd

# Airflow config and start script
RUN mkdir /usr/local/etc/airflow
COPY configs/airflow.cfg /usr/local/etc/airflow
COPY scripts/start-airflow.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start-airflow.sh

USER postgres

RUN service postgresql restart && \
    createuser --superuser ${NB_USER} && \
    createdb ${NB_USER} ${NB_USER}

RUN service postgresql restart && \
    createuser airflow && \
    createdb airflow_metadata -O airflow 

# Upload demo database from https://postgrespro.com/education/demodb 
# Uncomment code below if needed
#USER ${NB_USER}
#
#RUN wget https://edu.postgrespro.com/demo-small-en.zip && \
#    unzip demo-small-en.zip && \
#    echo redspot | sudo -S service postgresql restart && \
#    psql -a -f  demo-small-en-20170815.sql

USER ${NB_USER}

# Proxy for Airflow UI and etc
RUN pip install jupyter-server-proxy && \
    jupyter serverextension enable --sys-prefix jupyter_server_proxy && \
    pip install --no-cache-dir psycopg2-binary ipython-sql

RUN pip install "apache-airflow[celery]==2.2.0" --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-2.2.0/constraints-3.8.txt"

# Airflow config and start script
#COPY configs/airflow.cfg /usr/local/etc/
#COPY scripts/start-airflow.sh /usr/local/bin/ 
#RUN chmod +x /usr/local/bin/start-airflow.sh
