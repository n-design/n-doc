ARG baseimage=ubuntu:18.04

FROM ${baseimage} as buildbase
LABEL maintainer="alexander.krumeich@n-design.de"

RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y \
    git \
    curl \
    unzip \
    make \
    lua5.3 \
    liblua5.3-dev \
    sqlite3 \
    libsqlite3-0 \
    libsqlite3-dev \
    && rm -rf /var/lib/apt/lists/*

RUN curl http://luarocks.github.io/luarocks/releases/luarocks-3.1.2.tar.gz | tar xz

WORKDIR /luarocks-3.1.2

RUN ./configure && make build && make install && \
    luarocks install lsqlite3 && \
    luarocks install luaunit && \
    luarocks install ftcsv

WORKDIR /

FROM ${baseimage}
ARG ctanmirror=http://www.ctan.org/tex-archive

RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y make git sqlite perl graphviz curl python-pygments

COPY --from=buildbase /luarocks-3.1.2/lua_modules/lib/lua/5.3/ /usr/local/lib/lua/5.3/
COPY --from=buildbase /luarocks-3.1.2/lua_modules/share/lua/5.3/ /usr/local/share/lua/5.3

RUN echo ${ctanmirror}

RUN curl -L ${ctanmirror}/systems/texlive/tlnet/install-tl-unx.tar.gz | tar xz
RUN mv install-tl-20* install-tl

COPY texlive.profile /install-tl
COPY texlive.packages /

WORKDIR /install-tl

RUN ./install-tl -profile=texlive.profile -repository=${ctanmirror}/systems/texlive/tlnet/ && cd .. && rm -r install-tl

RUN /usr/local/texlive/bin/x86_64-linux/tlmgr update --self

RUN /usr/local/texlive/bin/x86_64-linux/tlmgr install $(cat /texlive.packages) && rm /texlive.packages

ENV PATH=/usr/local/texlive/bin/x86_64-linux:$PATH

WORKDIR /data
RUN rm -r /install-tl

VOLUME ["/data"]

