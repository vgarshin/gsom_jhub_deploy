# Source jupyter/tensorflow-notebook is under copyright (c) Jupyter Development Team
# and distributed under the terms of the Modified BSD License

FROM quay.io/jupyter/tensorflow-notebook:tensorflow-2.14.0

USER root

RUN apt update -y && apt upgrade -y && \
    apt install -y libgtk-3-common libasound2 libdbus-glib-1-2 && \
    apt install -y tesseract-ocr tesseract-ocr-rus && \
    apt install -y poppler-utils

RUN apt install openssh-server tree htop tmux -y && \
    apt install graphviz -y && \
    rm -r /var/lib/apt/lists/*

USER $NB_UID

RUN pip install --upgrade pip

# ML packages and libraries
RUN pip install --no-cache-dir nltk lightgbm xgboost catboost \
    pydot pydotplus graphviz plumbum wordcloud plotly pymystem3 \
    stats hyperopt optuna langdetect natasha gensim word2vec \
    python-Levenshtein

# Utilities
RUN pip install --no-cache-dir boto3 s3fs psycopg2-binary tldextract \
    nbgitpuller kds xlsxwriter eli5

# DL packages and libraries
RUN pip install --no-cache-dir torch==2.0.1 torchvision==0.15.2 torchaudio==2.0.2

# OCR tools
RUN pip install --no-cache-dir pytesseract pdf2image

# Jupyter extensions
RUN pip install jupyter-server-proxy && \
    jupyter server extension enable --sys-prefix jupyter_server_proxy