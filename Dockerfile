# Building with alpine 3.14 works between 3.11 and 3.18
# open ssl 1.1 from 3.16 and below
# open ssl 3.0 support only added in linux 3.17 onwards https://debugpointnews.com/alpine-linux-3-17/
# open ssl 3.1 from 3.18
ARG ALPINE_VERSION=3.14
ARG RUBY_VERSION=3.2.2
FROM alpine:${ALPINE_VERSION} as tebako_build_env
RUN apk --no-cache add build-base cmake git bash   \
        autoconf boost-static boost-dev flex-dev bison make      \
        binutils-dev libevent-dev acl-dev sed python3 pkgconfig  \
        lz4-dev openssl-dev zlib-dev xz ninja zip unzip curl     \
        libunwind-dev libdwarf-dev gflags-dev elfutils-dev       \
        libevent-static openssl-libs-static lz4-static xz-dev    \
        zlib-static libunwind-static acl-static tar libffi-dev   \
        gdbm-dev yaml-dev yaml-static ncurses-dev ncurses-static \
        readline-dev readline-static p7zip ruby-dev gcompat      \
        gettext-dev gperf postgresql-libs postgresql-dev ruby-etc
RUN wget -q https://github.com/jemalloc/jemalloc/releases/download/5.2.1/jemalloc-5.2.1.tar.bz2 && \
        tar -xf jemalloc-5.2.1.tar.bz2 && \
        rm -rf jemalloc-5.2.1.tar.bz2 && \
        cd jemalloc-5.2.1 && \
        ./configure && \
        make -j$(nproc) && \
        make install
RUN gem install bundler tebako

FROM tebako_build_env as tebako_build_press
ARG RUBY_VERSION=3.2.2
ENV RUBY_VERSION=${RUBY_VERSION}
WORKDIR /app
RUN tebako setup -p=output/${RUBY_VERSION} -R=${RUBY_VERSION}

# RUN tebako setup -p=output/${RUBY_VERSION} -R=${RUBY_VERSION} && \
#         tar -czvf output-${RUBY_VERSION}.tar.gz output/${RUBY_VERSION} && \
#         rm -rf output
RUN tar -czf output-${RUBY_VERSION}.tar.gz output/${RUBY_VERSION} && \
        rm -rf output

## Building our app
FROM tebako_build_env as tebako_press
ARG RUBY_VERSION=3.2.2
ENV RUBY_VERSION=${RUBY_VERSION}
WORKDIR /app
COPY --from=tebako_build_press /app/output/${RUBY_VERSION} /app/output/${RUBY_VERSION}
# COPY --from=tebako_build_press /app/output-${RUBY_VERSION}.tar.gz /app/output-${RUBY_VERSION}.tar.gz
RUN tar -xf output-${RUBY_VERSION}.tar.gz
ENTRYPOINT [ "/bin/bash", "-c" ]
CMD [ "tebako" ]
COPY examples/pact /app/examples/pact
RUN tebako press -p=output/${RUBY_VERSION} -R ${RUBY_VERSION} --root=examples/pact --entry-point=app --output=pact-cli-${RUBY_VERSION}

## Testing out the app
FROM alpine:${ALPINE_VERSION} as app
ARG RUBY_VERSION=3.2.2
ENV RUBY_VERSION=${RUBY_VERSION}
COPY --from=tebako_press /app/pact-cli-${RUBY_VERSION} /usr/bin/pact-cli
ENTRYPOINT [ "/bin/sh", "-c" ]
CMD [ "pact-cli" ]
