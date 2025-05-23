# Source jupyter/minimal-notebook is under copyright (c) Jupyter Development Team
# and distributed under the terms of the Modified BSD License

FROM quay.io/jupyter/minimal-notebook:python-3.12.7

USER root

# Do not exclude man pages & other documentation
RUN rm /etc/dpkg/dpkg.cfg.d/excludes

# Reinstall all currently installed packages in order to get the man pages back
RUN apt-get update && \
    dpkg -l | grep ^ii | cut -d' ' -f3 | xargs apt-get install -y --reinstall && \
    apt install tree htop tmux -y && \
    apt install man-db manpages manpages-posix -y && \
    mv /usr/bin/man.REAL /usr/bin/man -f && \
    rm -r /var/lib/apt/lists/*

USER $NB_UID

RUN pip install --upgrade pip

# Modules, packages and libraries
RUN pip install --no-cache-dir nbgitpuller

# Jupyter extensions
RUN pip install jupyter-server-proxy && \
    jupyter server extension enable --sys-prefix jupyter_server_proxy

# C++ kernel install https://github.com/jupyter-xeus/xeus-cling/tree/main
# xeus-cling is a Jupyter kernel for C++ based on the C++ interpreter cling 
# and the native implementation of the Jupyter protocol xeus
RUN mamba install -y xeus-cling -c conda-forge && \
    mamba install -y xtensor xtensor-blas xwidgets \
    widgetsnbextension nlohmann_json=3.11.2 -c conda-forge