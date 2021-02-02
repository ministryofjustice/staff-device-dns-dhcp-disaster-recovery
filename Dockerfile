FROM ubuntu:latest

RUN DEBIAN_FRONTEND=noninteractive apt-get update -qq && \
 apt-get install -y curl unzip jq && \
 curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
 unzip awscliv2.zip && \
./aws/install

WORKDIR /app

COPY scripts .
RUN chmod +x ./restore-dns-dhcp-config.sh ./restore-service-container.sh

CMD ["echo", "Please use one of the make commands to run this."]
