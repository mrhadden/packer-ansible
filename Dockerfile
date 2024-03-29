FROM docker.mirror.hashicorp.services/alpine:latest
LABEL maintainer="The Packer Team <packer@hashicorp.com>"

#ENV PACKER_VERSION=1.7.10
#ENV PACKER_SHA256SUM=1c8c176dd30f3b9ec3b418f8cb37822261ccebdaf0b01d9b8abf60213d1205cb
ENV PACKER_VERSION=1.8.3
ENV PACKER_SHA256SUM=0587f7815ed79589cd9c2b754c82115731c8d0b8fd3b746fe40055d969facba5



RUN apk add --update git bash wget openssl
RUN apk --update --no-cache add libc6-compat git curl openssh-client py-pip python3 && pip install awscli
#RUN apk --update add coreutils && rm -rf /var/cache/apk/*
#RUN apk --update add coreutils

ADD https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip ./
ADD https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_SHA256SUMS ./

RUN sed -i '/.*linux_amd64.zip/!d' packer_${PACKER_VERSION}_SHA256SUMS
RUN sha256sum -cs packer_${PACKER_VERSION}_SHA256SUMS
RUN unzip packer_${PACKER_VERSION}_linux_amd64.zip -d /bin
RUN rm -f packer_${PACKER_VERSION}_linux_amd64.zip

RUN apk add --update --no-cache bash openssh sshpass

RUN apk add --update --no-cache coreutils

RUN apk update && \
apk add --no-cache ansible && \
rm -rf /tmp/* && \
rm -rf /var/cache/apk/*

ENTRYPOINT ["/bin/packer"]