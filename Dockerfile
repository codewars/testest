FROM ubuntu:18.04

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

RUN set -ex; \
    mkdir -p /opt; \
    cd /opt; \
    wget -q -O - https://downloads.factorcode.org/releases/0.98/factor-linux-x86-64-0.98.tar.gz | tar xzf -; \
# To minimize the size, remove misc/ (editor support, icons), some of extra/ (extra libs and apps)
    rm -rf \
        /opt/factor/misc \
        /opt/factor/extra/bunny \
        /opt/factor/extra/images/testing \
        /opt/factor/extra/usa-cities \
        /opt/factor/extra/clutter \
        /opt/factor/extra/gstreamer \
        /opt/factor/extra/websites \
        /opt/factor/extra/benchmark \
        /opt/factor/extra/gpu \
        /opt/factor/extra/snake-game \
        /opt/factor/extra/project-euler \
        /opt/factor/extra/rosetta-code \
        /opt/factor/extra/audio/engine/test \
        /opt/factor/extra/talks \
    ;

# Deploy testest library
#RUN set -ex; \
#    (cd /opt/factor; ./factor -run=codewars.imager)

ENV PATH=/opt/factor:$PATH \
    FACTOR_ROOTS=/workspace

USER codewarrior
WORKDIR /workspace