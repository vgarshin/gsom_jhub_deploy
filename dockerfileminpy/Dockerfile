FROM jupyter/minimal-notebook:latest

USER root

# Do not exclude man pages & other documentation
RUN rm /etc/dpkg/dpkg.cfg.d/excludes

# Reinstall all currently installed packages in order to get the man pages back
RUN apt-get update && \
    dpkg -l | grep ^ii | cut -d' ' -f3 | xargs apt-get install -y --reinstall && \
    apt install man-db manpages manpages-posix -y && \
    mv /usr/bin/man.REAL /usr/bin/man -f && \
    rm -r /var/lib/apt/lists/*

USER $NB_UID

RUN pip install jupyter-server-proxy && \
    jupyter serverextension enable --sys-prefix jupyter_server_proxy

RUN pip install --no-cache-dir nbgitpuller
