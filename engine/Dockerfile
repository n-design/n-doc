# Dockerfile zum Erstellen der n-doc Umgebung,
# bestehend aus TeXLive, sqlite und lua

# Die Reihenfolge der Blöcke basiert auf der
# Veränderungshäufigkeit der jeweils installierten
# Pakete:
# Ubuntu-Basis -> TeXLive -> Verschiedene Dev-Tools ->
# plantuml -> zusätzliche TeXLive Pakete

FROM ubuntu:18.04

RUN apt-get update && apt-get install -y wget perl

# Installiere eine reduzierte Variante von TeXLive von CTAN
# und ergänze sie durch die Pakete, die für n-doc notwendig sind.

WORKDIR /usr/local/src
RUN wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz && tar xzf install-tl-unx.tar.gz \
    && mv install-tl-20* install-tl
WORKDIR install-tl
COPY texlive.profile /usr/local/src/tl-install/texlive.profile
RUN ./install-tl -profile=/usr/local/src/tl-install/texlive.profile
ENV PATH /usr/local/texlive/2018/bin/x86_64-linux:$PATH

RUN apt-get install -y \
    git \
    curl \
    unzip \
    lua5.2 \
    liblua5.2-dev \
    sqlite3 \
    libsqlite3-0 \
    libsqlite3-dev \
    openjdk-8-jre \
    graphviz \
&& rm -rf /var/lib/apt/lists/*

# Installiere den Lua Package-Manager aus den Quellen.

WORKDIR /usr/local/src
RUN wget http://luarocks.github.io/luarocks/releases/luarocks-2.4.3.tar.gz \
    && tar xzf luarocks-2.4.3.tar.gz
WORKDIR luarocks-2.4.3
RUN ./configure && make build && make install
RUN luarocks install lsqlite3 
RUN luarocks install luaunit


# Installiere plantuml
COPY plantuml.tar.gz /usr/local/src
RUN tar x -z -C / -f /usr/local/src/plantuml.tar.gz

# Installiere zusätzliche TeXLive Pakete
RUN /usr/local/texlive/2018/bin/i386-linux/tlmgr update --self && \
/usr/local/texlive/2018/bin/i386-linux/tlmgr install \
  adjustbox \
  biber\
  biblatex \
  collectbox \
  csquotes \
  datatool \
  enumitem \
  gitinfo2 \
  glossaries \
  gnu-freefont \
  ifmtarg \
  logreq \
  ltablex \
  mfirstuc \
  minibox \
  nimbus15 \
  pgf-umlsd \
  placeins \
  relsize \
  roboto \
  splitindex \
  substr \
  tocloft \
  xfor \
  xifthen \
  xstring

RUN /usr/local/texlive/2018/bin/x86_64-linux/luaotfload-tool --update -vv

WORKDIR /data
VOLUME /deliverables
