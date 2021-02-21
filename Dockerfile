FROM crystallang/crystal:0.36.1-alpine

ADD . /app
WORKDIR /app

RUN shards build --release

CMD ["bin/crystal-docker-example"]
