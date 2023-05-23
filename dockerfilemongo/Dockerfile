# https://github.com/jupyter/docker-stacks/blob/master/minimal-notebook/Dockerfile
# Source jupyter/minimal-notebook is under copyright (c) Jupyter Development Team.
# and distributed under the terms of the Modified BSD License.

FROM jupyter/minimal-notebook:python-3.10.9

# This dockerfile is for MongoDB demo purposes

USER root

# MongoBD install
RUN apt-get update && sudo apt-get install -y libcurl4 openssl liblzma5 && \
    wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu2204-6.0.4.tgz && \
    tar -zxvf mongodb-linux-*-6.0.4.tgz && rm mongodb-linux-*-6.0.4.tgz && \
    sudo mv mongodb-linux-x86_64-ubuntu2204-6.0.4/bin/* /usr/local/bin/

# mongosh client ibstall
RUN apt-get update && apt-get install -y gnupg && \
    wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add - && \
    echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list && \
    sudo apt-get update && sudo apt-get install -y mongodb-mongosh

# folders for MongoBD data and logs
RUN mkdir -p /var/lib/mongo
RUN chown -R jovyan:users /var/lib/mongo
RUN mkdir -p /var/log/mongodb
RUN chown -R jovyan:users /var/log/mongodb

# user's permissions
RUN echo "jovyan ALL=(ALL)   ALL" >> /etc/sudoers
RUN echo "jovyan:redspot" | chpasswd

USER 1000

RUN pip install --no-cache-dir pymongo
