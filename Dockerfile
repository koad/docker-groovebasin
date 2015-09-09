# GrooveBasin image
# ORIGINAL MAINTAINER Simon Morvan garphy@zone84.net
# Modified to use stackbrew and remove supervisord
# use stackbrew's super-small ubuntu
FROM stackbrew/ubuntu:12.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y python-software-properties && \
    apt-add-repository ppa:andrewrk/libgroove && \
    apt-add-repository ppa:chris-lea/node.js && \
    apt-get update && \
    apt-get -y install build-essential && \
    apt-get -y install libgroove-dev libgrooveplayer-dev \
    libgrooveloudness-dev libgroovefingerprinter-dev && \
    apt-get -y install nodejs && \
    npm -g install groovebasin && \
    apt-get -y remove libgroove-dev libgrooveplayer-dev \
    libgrooveloudness-dev libgroovefingerprinter-dev \
    manpages manpages-dev g++ gcc cpp make ucf \
    python-software-properties unattended-upgrades \
    g++-4.6 gcc-4.6 cpp-4.6 && \
    apt-get clean

RUN useradd -m groovebasin -G audio && \
    mkdir /music && touch /music/.dummy && \
    chown groovebasin:groovebasin /music && \
    mkdir /groove && touch /groove/.dummy && \
    chown groovebasin:groovebasin /groove

USER groovebasin

ENV HOME /home/groovebasin
ENV NODE_PATH /usr/lib/node_modules
RUN ln -s /music /home/groovebasin/music && \
    ln -s /groove /home/groovebasin/groovebasin.db
WORKDIR /home/groovebasin

EXPOSE 16242
EXPOSE 6600

VOLUME /music
VOLUME /groove

ENTRYPOINT ["node","/usr/lib/node_modules/groovebasin/lib/server.js"]
