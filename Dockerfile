FROM python:2.7-stretch

RUN mkdir -p /app
WORKDIR /app
ADD ./ /app

RUN apt-get update && \
    apt-get install -y \
      jq \
      netcat \
      postgresql-client \
      libssl-dev \
      libxml2-dev \
      libxslt1-dev \
      libsasl2-dev \
      libldap2-dev && \
    pip install -e '.[postgresql]' && \
    pip install yq && \
    python setup.py install

CMD /app/docker-entrypoint.sh
