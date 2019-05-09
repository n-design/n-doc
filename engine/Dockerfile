FROM ubuntu as buildbase
LABEL maintainer="alexander.krumeich@n-design.de"

RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y \
    git \
    curl \
    unzip \
    lua5.2 \
    liblua5.2-dev \
    sqlite3 \
    libsqlite3-0 \
    libsqlite3-dev \
&& rm -rf /var/lib/apt/lists/*

FROM buildbase as ndocbuild

RUN curl http://luarocks.github.io/luarocks/releases/luarocks-2.4.3.tar.gz | tar xz

WORKDIR /luarocks-2.4.3

RUN ./configure && make build && make install && \
    luarocks install lsqlite3 && \
    luarocks install luaunit

WORKDIR /

FROM ubuntu

RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y make git sqlite perl openjdk-8-jre graphviz curl python-pygments

COPY --from=ndocbuild /usr/local/lib/lua/5.2 /usr/local/lib/lua/5.2
COPY --from=ndocbuild /usr/local/share/lua/5.2/ /usr/local/share/lua/5.2/

COPY plantuml.tar.gz /

RUN tar x -C / -f /plantuml.tar.gz

RUN curl -L http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz | tar xz
RUN mv install-tl-20* install-tl

COPY texlive.profile /install-tl

WORKDIR /install-tl

RUN ./install-tl -profile=texlive.profile -repository=http://ftp.fau.de/ctan/systems/texlive/tlnet

RUN /usr/local/texlive/2018/bin/x86_64-linux/tlmgr install \
  biber \
  gnu-freefont \
  lm \
  nimbus15 \
  roboto \
  koma-script \
  xindy

RUN /usr/local/texlive/2018/bin/x86_64-linux/tlmgr install latexmk \
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




ENV PATH=/usr/local/texlive/2018/bin/x86_64-linux:$PATH

WORKDIR /data
VOLUME ["/data"]
