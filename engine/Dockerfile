ARG baseimage=ubuntu:22.04

FROM ${baseimage} as buildbase
LABEL maintainer="alexander.krumeich@n-design.de"

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y upgrade && apt-get install -y \
    lua5.3 \
    liblua5.3-dev \
    libsqlite3-dev \
    luarocks \
    && rm -rf /var/lib/apt/lists/*

RUN luarocks install lsqlite3 && \
    luarocks install luaunit && \
    luarocks install ftcsv

FROM ${baseimage} as ndocbase

ARG TARGETPLATFORM
ARG TARGETARCH
ARG TARGETOS

WORKDIR /install-tl
COPY texlive.profile-$TARGETARCH-linux /install-tl/texlive.profile
ENV PATH=/usr/local/texlive/bin/x86_64-linux:/usr/local/texlive/bin/aarch64-linux:$PATH

COPY --from=buildbase /usr/local/lib/lua/5.3/lsqlite3.so /usr/local/lib/lua/5.3/
COPY --from=buildbase /usr/local/share/lua/5.3/ /usr/local/share/lua/5.3

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y make sqlite3 git graphviz curl python3-pygments

ARG ctanmirror=http://ftp.fau.de/ctan

RUN curl -L ${ctanmirror}/systems/texlive/tlnet/install-tl-unx.tar.gz | tar xz --strip-components 1 && \
    ./install-tl -profile=texlive.profile -repository=${ctanmirror}/systems/texlive/tlnet/ && \
    cd / && \
    rm -r /install-tl

COPY texlive.packages /
RUN tlmgr install $(cat /texlive.packages) && \
    rm /texlive.packages

ENV TEXMFCACHE=./.texmfcache
ADD l.sh /usr/local/bin

WORKDIR /data

RUN git config --system --add safe.directory *

VOLUME ["/data"]

