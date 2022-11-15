FROM jupyter/tensorflow-notebook:tensorflow-2.4.3

USER root

RUN apt update && apt install build-essential -y && \
    apt install firefox -y

RUN wget https://github.com/mozilla/geckodriver/releases/download/v0.32.0/geckodriver-v0.32.0-linux64.tar.gz && \
    tar -xvzf geckodriver* && chmod +x geckodriver && mv geckodriver /usr/local/bin/ && rm geckodriver*

RUN apt install openssh-server tree htop tmux -y && \
    apt install graphviz -y && \
    rm -r /var/lib/apt/lists/*

USER $NB_UID

RUN pip install --upgrade pip

RUN pip install jupyter-server-proxy && \
    jupyter serverextension enable --sys-prefix jupyter_server_proxy

RUN pip install --no-cache-dir nltk lightgbm xgboost catboost \
    pydot pydotplus graphviz plumbum wordcloud plotly pymystem3 \
    stats hyperopt torch torchvision tensorflow_addons pymorphy2 \
    boto3 s3fs psycopg2-binary langdetect tldextract selenium \
    scrapy natasha gensim word2vec graphviz dash jupyter-dash \
    python-Levenshtein nbgitpuller kds xlsxwriter eli5
