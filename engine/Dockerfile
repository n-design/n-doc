ARG baseimage=ubuntu:20.04

FROM ${baseimage} as buildbase
LABEL maintainer="alexander.krumeich@n-design.de"

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y \
    curl \
    unzip \
    make \
    lua5.3 \
    liblua5.3-dev \
    sqlite3 \
    libsqlite3-0 \
    libsqlite3-dev \
    && rm -rf /var/lib/apt/lists/*

RUN curl http://luarocks.github.io/luarocks/releases/luarocks-3.7.0.tar.gz | tar xz

WORKDIR /luarocks-3.7.0

RUN ./configure && make build && make install && \
    luarocks install lsqlite3 && \
    luarocks install luaunit && \
    luarocks install ftcsv

FROM ${baseimage}
ARG ctanmirror=http://www.ctan.org/tex-archive

ENV DEBIAN_FRONTEND=noninteractive

COPY --from=buildbase /luarocks-3.7.0/lua_modules/lib/lua/5.3/ /usr/local/lib/lua/5.3/
COPY --from=buildbase /luarocks-3.7.0/lua_modules/share/lua/5.3/ /usr/local/share/lua/5.3

COPY texlive.profile /
COPY texlive.packages /

RUN apt-get update && apt-get install -y make sqlite3 git graphviz curl python3-pygments

WORKDIR /install-tl

RUN curl -L ${ctanmirror}/systems/texlive/tlnet/install-tl-unx.tar.gz | tar xz --strip-components 1 && \
    ./install-tl -profile=/texlive.profile -repository=${ctanmirror}/systems/texlive/tlnet/ && \
    cd / && \
    rm -r /install-tl && \
    /usr/local/texlive/bin/x86_64-linux/tlmgr install $(cat /texlive.packages) && \
    rm /texlive.packages

ENV TEXMFCACHE=./.texmfcache
ADD l.sh /usr/local/bin

ENV PATH=/usr/local/texlive/bin/x86_64-linux:$PATH

WORKDIR /data

VOLUME ["/data"]

