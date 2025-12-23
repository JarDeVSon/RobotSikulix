FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    openjdk-11-jdk \
    xvfb \
    libxrender1 \
    libxtst6 \
    libxi6 \
    git \
    wget \
    unzip \
    && apt-get clean

RUN pip3 install robotframework

WORKDIR /tests
