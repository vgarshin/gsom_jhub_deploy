# https://github.com/jupyter/docker-stacks/blob/master/minimal-notebook/Dockerfile
# Source jupyter/minimal-notebook is under copyright (c) Jupyter Development Team.
# and distributed under the terms of the Modified BSD License.

FROM jupyter/minimal-notebook:python-3.10.9

# This dockerfile is based on an original Dockerfile by Daniel Chudnov <dchud@umich.edu>
# https://github.com/dchud/datamanagement-notebook/blob/master/Dockerfile
# and by Tony Hirst
# https://github.com/psychemedia/jupyter-postgres-demo/blob/sudoers/Dockerfile

USER root

RUN apt-get update && apt-get install -y gnupg && \
    sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list' && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add - && \
    apt-get -y install postgresql && apt install -y libpq-dev

RUN chown -R postgres:postgres /var/run/postgresql
RUN echo "jovyan ALL=(ALL)   ALL" >> /etc/sudoers
RUN echo "jovyan:redspot" | chpasswd

USER postgres

RUN service postgresql restart && \
    createuser --superuser ${NB_USER} && \
    createdb ${NB_USER} ${NB_USER}

USER 1000

# Upload demo database from https://postgrespro.com/education/demodb
# Uncomment code below if needed
#RUN wget https://edu.postgrespro.com/demo-small-en.zip && \
#    unzip demo-small-en.zip && \
#    echo redspot | sudo -S service postgresql restart && \
#    psql -a -f  demo-small-en-20170815.sql

RUN pip install --no-cache-dir psycopg2-binary ipython-sql
