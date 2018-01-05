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

WORKDIR /usr/local/src
RUN wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz && tar xzf install-tl-unx.tar.gz \
    && mv install-tl-20* install-tl
WORKDIR install-tl
COPY texlive.profile /usr/local/src/tl-install/texlive.profile
RUN ./install-tl -profile=/usr/local/src/tl-install/texlive.profile
ENV PATH /usr/local/texlive/2017/bin/x86_64-linux:$PATH
RUN /usr/local/texlive/2017/bin/i386-linux/tlmgr install koma-script csquotes \
  etoolbox minibox l3kernel booktabs enumitem pgf xcolor adjustbox xkeyval \
  collectbox relsize xifthen ifmtarg biblatex biber\
  logreq xstring fontspec gnu-freefont tocloft latexmk \
  glossaries mfirstuc textcase xfor  datatool substr fp \
  babel  babel-german babel-english ulem \
  luapackageloader luacode luatexbase ctablestack gnu-freefont \
  ec lm luaotfload latexmk tracklang

WORKDIR /usr/local/texlive/texmf-local/tex/latex/local
RUN wget http://perso.ensta-paristech.fr/~kielbasi/tikzuml/var/files/src/tikzuml-v1.0-2016-03-29.tbz \
    && tar xjf tikzuml-v1.0-2016-03-29.tbz \
    && texhash

WORKDIR /data
VOLUME /deliverables