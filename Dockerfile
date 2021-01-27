FROM ubuntu:latest

RUN apt-get update -qq && apt-get install -y curl unzip jq && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install

WORKDIR /app

COPY scripts/restore-config.sh ./restore-config.sh
RUN chmod +x ./restore-config.sh

ENTRYPOINT "./restore-config.sh"
