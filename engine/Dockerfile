ARG baseimage=ubuntu:22.04

# This is the builder part of the Dockerfile
# It's used to install three Lua libraries required 
# for n-doc. 

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

# This is the n-doc image proper. 

FROM ${baseimage} as ndocbase

ARG TARGETPLATFORM
ARG TARGETARCH
ARG TARGETOS

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH=/usr/local/texlive/bin/x86_64-linux:/usr/local/texlive/bin/aarch64-linux:$PATH
ENV TEXMFCACHE=./.texmfcache

RUN apt-get update && apt-get install -y make sqlite3 git graphviz curl python3-pygments

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

