FROM jupyter/tensorflow-notebook:latest

USER root

RUN sudo apt update && apt-get install firefox -y

RUN wget https://github.com/mozilla/geckodriver/releases/download/v0.29.1/geckodriver-v0.29.1-linux64.tar.gz && \
    tar -xvzf geckodriver* && chmod +x geckodriver && mv geckodriver /usr/local/bin/

USER $NB_UID

RUN pip install jupyter-server-proxy && \
    jupyter serverextension enable --sys-prefix jupyter_server_proxy

RUN pip install --no-cache-dir nltk lightgbm xgboost catboost \
	pydot pydotplus graphviz plumbum wordcloud plotly pymystem3 \
	stats hyperopt torch torchvision tensorflow_addons pymorphy2 \
	boto3 s3fs psycopg2-binary langdetect tldextract selenium \
        scrapy natasha gensim word2vec graphviz dash jupyter-dash \
        python-Levenshtein
