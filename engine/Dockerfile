ARG baseimage=ubuntu:22.04

# This is the builder part of the Dockerfile
# It's used to install three Lua libraries required 
# for n-doc. 

FROM ${baseimage} AS buildbase
LABEL maintainer="alexander.krumeich@n-design.de"

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y upgrade && apt-get install -y \
    lua5.3 \
    liblua5.3-dev \
    libsqlite3-dev \
    luarocks \
    && apt autoremove --purge && apt clean && rm -rf /var/lib/apt/lists/*

RUN luarocks install luaunit && \
    luarocks install ftcsv

# Install lsqlite3 manually, since the luarocks server
# now requires no-robot authentication via JavaScript
# see https://lua.sqlite.org/home/info/4a118ffd0cea06f91fee5754b8a1b5ce4ba6699f
#
# That means for now we have to install lsqlite3 manually
# from the rock file added to the image
COPY lsqlite3_v096.zip /
RUN unzip lsqlite3_v096.zip
WORKDIR lsqlite3_v096
RUN luarocks make lsqlite3-0.9.6-1.rockspec


# This is the n-doc image proper. 

FROM ${baseimage} AS ndocbase

ARG TARGETPLATFORM
ARG TARGETARCH
ARG TARGETOS

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH=/usr/local/texlive/bin/x86_64-linux:/usr/local/texlive/bin/aarch64-linux:$PATH
ENV TEXMFCACHE=./.texmfcache

RUN apt-get update && apt-get install -y make sqlite3 git graphviz curl python3-pygments \
    && apt autoremove --purge && apt clean && rm -rf /var/lib/apt/lists/*

COPY --from=buildbase /usr/local/lib/lua/5.3/lsqlite3.so /usr/local/lib/lua/5.3/
COPY --from=buildbase /usr/local/share/lua/5.3/ /usr/local/share/lua/5.3
COPY texlive.profile-$TARGETARCH-linux /install-tl/texlive.profile
COPY texlive.packages /install-tl
COPY l.sh /usr/local/bin

WORKDIR /install-tl

ARG ctanmirror=http://ftp.fau.de/ctan

RUN curl -L ${ctanmirror}/systems/texlive/tlnet/install-tl-unx.tar.gz | tar xz --strip-components 1 && \
    ./install-tl -profile=texlive.profile -repository=${ctanmirror}/systems/texlive/tlnet/ && \
    tlmgr install $(cat texlive.packages) && \
    cd / && \
    rm -r /install-tl

WORKDIR /data

RUN git config --system --add safe.directory *

VOLUME ["/data"]

