FROM ubuntu:18.04

ARG RELEASE=master
ARG FACTOR_URL=https://downloads.factorcode.org/releases/0.98/factor-linux-x86-64-0.98.tar.gz
ARG TESTEST_URL=https://raw.githubusercontent.com/codewars/testest/$RELEASE
ARG INSTALL_DIR=/opt
ENV FACTOR_DIR=$INSTALL_DIR/factor

ENV LANG=C.UTF-8

RUN set -ex; \
    useradd --create-home codewarrior; \
    mkdir -p /workspace; \
    chown -R codewarrior:codewarrior /workspace;

RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        wget \
        ca-certificates \
    ; \
    rm -rf /var/lib/apt/lists/*;

COPY docker/ /scripts/docker/

RUN set -ex; \
    cd $INSTALL_DIR; \
    wget -q -O - $FACTOR_URL | tar xzf -; \
# To minimize the size, remove misc/ (editor support, icons), some of extra/ (extra libs and apps)
    rm -rf \
        $FACTOR_DIR/misc \
        $FACTOR_DIR/extra/bunny \
        $FACTOR_DIR/extra/images/testing \
        $FACTOR_DIR/extra/usa-cities \
        $FACTOR_DIR/extra/clutter \
        $FACTOR_DIR/extra/gstreamer \
        $FACTOR_DIR/extra/websites \
        $FACTOR_DIR/extra/benchmark \
        $FACTOR_DIR/extra/gpu \
        $FACTOR_DIR/extra/snake-game \
        $FACTOR_DIR/extra/project-euler \
        $FACTOR_DIR/extra/rosetta-code \
        $FACTOR_DIR/extra/audio/engine/test \
        $FACTOR_DIR/extra/talks; \
# install library
    bash - < /scripts/docker/deploy.sh; \
# reimage factor.image
    (cd $FACTOR_DIR; ./factor -run=codewars.imager)

ENV PATH=$FACTOR_DIR:$PATH \
    FACTOR_ROOTS=/workspace

USER codewarrior
WORKDIR /workspace
