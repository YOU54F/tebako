
ARG ALPINE_VERSION=3.14
FROM alpine:${ALPINE_VERSION} as stage1 
ARG ALPINE_VERSION=3.14
ENV ALPINE_VERSION=$ALPINE_VERSION
ARG RUBY_VERSION=3.2.2
ENV RUBY_VERSION=${RUBY_VERSION}
# open ssl 1.1 from 3.16 and below
# open ssl 3.0 support only added in linux 3.17 onwards https://debugpointnews.com/alpine-linux-3-17/
# open ssl 3.1 from 3.18

# Setup build environment for rubyc
RUN apk --no-cache --upgrade add build-base cmake git bash   \
        autoconf boost-static boost-dev flex-dev bison make      \
        binutils-dev libevent-dev acl-dev sed python3 pkgconfig  \
        lz4-dev openssl-dev zlib-dev xz ninja zip unzip curl     \
        libunwind-dev libdwarf-dev gflags-dev elfutils-dev       \
        libevent-static openssl-libs-static lz4-static xz-dev    \
        zlib-static libunwind-static acl-static tar libffi-dev   \
        gdbm-dev yaml-dev yaml-static ncurses-dev ncurses-static \
        readline-dev readline-static p7zip ruby-dev gcompat      \
        gettext-dev gperf postgresql-libs
      #       apk cache clean && \
      #       rm -rf /var/cache/apk/* && \
      #       rm -rf /tmp/* && \
      #       rm -rf /var/log/*
# bash is needed to detect the OS (CMakeLists.txt#L135)
# ruby-etc needed for alpine 3.14 and maybe below

RUN wget -q https://github.com/jemalloc/jemalloc/releases/download/5.2.1/jemalloc-5.2.1.tar.bz2 && \
        tar -xf jemalloc-5.2.1.tar.bz2 && \
        cd jemalloc-5.2.1 && \
        ./configure && \
        make -j4 && \
        make install
RUN gem install bundler
RUN gem install tebako
RUN cmake --version
WORKDIR /app
ENV CXX=g++
ENV CC=gcc
RUN ruby --version && apk add ruby-etc
RUN tebako setup -p=output/3.2.2 -R=3.2.2
# ENTRYPOINT [ "/bin/bash", "-c" ]
# CMD [ "tebako" ]

COPY examples/pact /app/examples/pact
RUN apk add postgresql-dev
RUN tebako press -p=output/3.2.2 -R 3.2.2 --root=examples/pact --entry-point=app --output=pact-cli-3.2.2
ENTRYPOINT [ "/app/pact-cli-3.2.2" ]

# Building with alpine 3.14 works between 3.11 and 3.18
FROM alpine:3.11
COPY --from=stage1 /app/pact-cli-3.2.2 /usr/local/bin/pact-cli
RUN pact-cli broker version
ENTRYPOINT [ "pact-cli" ]
FROM alpine:3.12
COPY --from=stage1 /app/pact-cli-3.2.2 /usr/local/bin/pact-cli
RUN pact-cli broker version
ENTRYPOINT [ "pact-cli" ]
FROM alpine:3.13
COPY --from=stage1 /app/pact-cli-3.2.2 /usr/local/bin/pact-cli
RUN pact-cli broker version
ENTRYPOINT [ "pact-cli" ]
FROM alpine:3.14
COPY --from=stage1 /app/pact-cli-3.2.2 /usr/local/bin/pact-cli
RUN pact-cli broker version
ENTRYPOINT [ "pact-cli" ]
FROM alpine:3.15
COPY --from=stage1 /app/pact-cli-3.2.2 /usr/local/bin/pact-cli
RUN pact-cli broker version
ENTRYPOINT [ "pact-cli" ]
FROM alpine:3.16
COPY --from=stage1 /app/pact-cli-3.2.2 /usr/local/bin/pact-cli
RUN pact-cli broker version
ENTRYPOINT [ "pact-cli" ]
FROM alpine:3.17
COPY --from=stage1 /app/pact-cli-3.2.2 /usr/local/bin/pact-cli
RUN pact-cli broker version
ENTRYPOINT [ "pact-cli" ]
FROM alpine:3.18
COPY --from=stage1 /app/pact-cli-3.2.2 /usr/local/bin/pact-cli
RUN pact-cli broker version
ENTRYPOINT [ "pact-cli" ]