FROM ubuntu:latest

RUN apt-get update -qq && apt-get install -y curl unzip jq && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install

WORKDIR /app

COPY scripts .

CMD ["echo", "Please use one of the make commands to run this."]
