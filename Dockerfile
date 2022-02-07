FROM ubuntu:18.04

ARG FACTOR_VERSION=0.98
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

COPY tools/testest/testest.factor /opt/factor/work/tools/testest/testest.factor
COPY codewars/imager/imager.factor /opt/factor/work/codewars/imager/imager.factor
COPY math/margins/margins.factor /opt/factor/pre/math/margins/margins.factor

RUN set -ex; \
    cd /opt; \
    wget -q -O - https://downloads.factorcode.org/releases/${FACTOR_VERSION}/factor-linux-x86-64-${FACTOR_VERSION}.tar.gz | tar xzf -; \
# To minimize the size, remove misc/ (editor support, icons), some of extra/ (extra libs and apps)
    cd /opt/factor; \
    rm -rf \
        ./misc \
        ./extra/bunny \
        ./extra/images/testing \
        ./extra/usa-cities \
        ./extra/clutter \
        ./extra/gstreamer \
        ./extra/websites \
        ./extra/benchmark \
        ./extra/gpu \
        ./extra/snake-game \
        ./extra/project-euler \
        ./extra/rosetta-code \
        ./extra/audio/engine/test \
        ./extra/talks \
    ; \
# reimage factor.image
    ./factor -run=codewars.imager;

ENV PATH=/opt/factor:$PATH \
    FACTOR_ROOTS=/workspace

USER codewarrior
WORKDIR /workspace
