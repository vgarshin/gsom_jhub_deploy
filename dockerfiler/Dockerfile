# Source jupyter/minimal-notebook is under copyright (c) Jupyter Development Team
# and distributed under the terms of the Modified BSD License

FROM quay.io/jupyter/r-notebook:python-3.12.7

RUN pip install --upgrade pip

# Modules, packages and libraries
RUN pip install --no-cache-dir nbgitpuller

# Jupyter extensions
RUN pip install jupyter-server-proxy && \
    jupyter server extension enable --sys-prefix jupyter_server_proxy

# -= Future releases =-
# Elyra extension https://github.com/elyra-ai/elyra
# does not support JupyterLab >= 4.x
#RUN pip install --upgrade elyra-code-snippet-extension && \
#    pip install --upgrade elyra-python-editor-extension && \
#    jupyter server extension enable elyra