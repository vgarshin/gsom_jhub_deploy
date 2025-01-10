# Source jupyter/tensorflow-notebook is under copyright (c) Jupyter Development Team
# and distributed under the terms of the Modified BSD License

FROM quay.io/jupyter/tensorflow-notebook:python-3.12.7

USER root

ENV FF_VER 105.0

ENV FF_DIR /dist

RUN apt update -y && apt upgrade -y && \
    apt install -y libgtk-3-common libasound2t64 libdbus-glib-1-2 && \
    apt install sqlite3 -y && \
    apt install -y tesseract-ocr tesseract-ocr-rus && \
    apt install -y poppler-utils

RUN mkdir -p $FF_DIR && cd $FF_DIR && \
    wget -O - https://ftp.mozilla.org/pub/firefox/releases/$FF_VER/linux-x86_64/en-US/firefox-$FF_VER.tar.bz2 | tar -xjf -

ENV PATH $FF_DIR/firefox:$PATH

RUN wget https://github.com/mozilla/geckodriver/releases/download/v0.33.0/geckodriver-v0.33.0-linux64.tar.gz && \
    tar -xvzf geckodriver* && chmod +x geckodriver && mv geckodriver /usr/local/bin/ && rm geckodriver*

RUN apt install openssh-server tree htop tmux -y && \
    apt install graphviz -y && \
    rm -r /var/lib/apt/lists/*

USER $NB_UID

RUN pip install --upgrade pip

# ML packages and libraries
RUN pip install --no-cache-dir nltk lightgbm xgboost catboost \
    pydot pydotplus graphviz plumbum wordcloud plotly pymystem3 \
    stats hyperopt optuna langdetect natasha gensim word2vec \
    graphviz python-Levenshtein

# Utilities
RUN pip install --no-cache-dir boto3 s3fs psycopg2-binary tldextract \
    selenium scrapy nbgitpuller kds xlsxwriter eli5

# DL packages and libraries
RUN pip install --no-cache-dir torch torchvision

# LLM chat-bot interface
# NOTE: requires jupyterlab>=4.0.0
#       incompatible with `elyra` extentions below
#RUN pip install --no-cache-dir jupyter-ai gpt4all

# OCR tools
RUN pip install --no-cache-dir pytesseract pdf2image

# Jupyter extensions
RUN pip install jupyter-server-proxy && \
    jupyter server extension enable --sys-prefix jupyter_server_proxy

# -= Future releases =-
# Elyra extension https://github.com/elyra-ai/elyra
# does not support JupyterLab >= 4.x
#RUN pip install --upgrade elyra-code-snippet-extension && \
#    pip install --upgrade elyra-python-editor-extension && \
#    jupyter server extension enable elyra