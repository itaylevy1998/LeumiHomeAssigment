FROM ubuntu:22.04

RUN apt-get update && apt-get install -y curl docker.io unzip \
    && curl -SL https://github.com/docker/compose/releases/download/v2.32.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose \
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm awscliv2.zip \
    && curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && chmod +x kubectl \
    && mv kubectl /usr/local/bin/kubectl \ 
    && curl -fsSL -o helm.tar.gz https://get.helm.sh/helm-v3.11.3-linux-amd64.tar.gz \ 
    && tar -zxvf helm.tar.gz \ 
    && mv linux-amd64/helm /usr/local/bin/helm




    
