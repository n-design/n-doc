FROM ubuntu as buildbase
LABEL maintainer="alexander.krumeich@n-design.de"

RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y \
    git \
    curl \
    unzip \
    lua5.3 \
    liblua5.3-dev \
    sqlite3 \
    libsqlite3-0 \
    libsqlite3-dev \
&& rm -rf /var/lib/apt/lists/*

FROM buildbase as ndocbuild

RUN curl http://luarocks.github.io/luarocks/releases/luarocks-3.1.2.tar.gz | tar xz

WORKDIR /luarocks-3.1.2

RUN ./configure && make build && make install && \
    luarocks install lsqlite3 && \
    luarocks install luaunit

WORKDIR /

FROM ubuntu

RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y make git sqlite perl openjdk-8-jre graphviz curl python-pygments

COPY --from=ndocbuild /luarocks-3.1.2/lua_modules/lib/lua/5.3/ /usr/local/lib/lua/5.3/
COPY --from=ndocbuild /luarocks-3.1.2/lua_modules/share/lua/5.3/ /usr/local/share/lua/5.3

COPY plantuml.tar.gz /

RUN tar x -C / -f /plantuml.tar.gz

RUN curl -L http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz | tar xz
RUN mv install-tl-20* install-tl

COPY texlive.profile /install-tl

WORKDIR /install-tl

RUN ./install-tl -profile=texlive.profile -repository=http://ftp.fau.de/ctan/systems/texlive/tlnet

RUN /usr/local/texlive/bin/x86_64-linux/tlmgr install \
  biber \
  gnu-freefont \
  lm \
  nimbus15 \
  roboto \
  koma-script \
  xindy

RUN /usr/local/texlive/bin/x86_64-linux/tlmgr install latexmk \
  adjustbox \
  booktabs \
  biblatex \
  booktabs \
  caption \
  collectbox \
  csquotes \
  datatool \
  dirtree \
  enumitem \
  eso-pic \
  etoolbox \
  fancybox \
  fancyvrb \
  float \
  fontspec \
  framed \
  fvextra \
  l3kernel \
  gitinfo2 \
  graphics \
  ifmtarg \
  ifplatform \
  imakeidx \
  lineno \
  logreq \
  ltablex \
  latexmk \
  listings \
  mdwtools \
  mfirstuc \
  minibox \
  minted \
  multirow \
  makecell \ 
  pgf-umlsd \
  placeins \
  relsize \
  splitindex \
  substr \
  pgf \
  tocloft \
  ulem \
  upquote \
  xcolor \
  xfor \
  xifthen \
  xkeyval \
  xltabular \
  xstring


ENV PATH=/usr/local/texlive/bin/x86_64-linux:$PATH

WORKDIR /data
VOLUME ["/data"]
