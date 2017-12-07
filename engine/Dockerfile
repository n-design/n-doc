# Use an official Python runtime as a parent image
FROM ubuntu:17.04

RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    unzip \
    lua5.2 \
    liblua5.2-dev \
    sqlite3 \
    libsqlite3-0 \
    libsqlite3-dev \
&& rm -rf /var/lib/apt/lists/*

WORKDIR /usr/local/src
RUN wget http://luarocks.github.io/luarocks/releases/luarocks-2.4.3.tar.gz \
    && tar xzf luarocks-2.4.3.tar.gz
WORKDIR luarocks-2.4.3
RUN ./configure && make build && make install
RUN luarocks install lsqlite3

CMD ["lua",  "-e", "l = require \"lsqlite3\"; print(l)"]

WORKDIR /usr/local/src
RUN wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz && tar xzf install-tl-unx.tar.gz \
    && mv install-tl-20* install-tl
WORKDIR install-tl
COPY texlive.profile .
RUN ./install-tl -profile /usr/local/src/tl-install/texlive.profile
