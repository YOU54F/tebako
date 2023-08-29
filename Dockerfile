FROM ubuntu:20.04 as stage1
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

RUN apt-get update -y && apt-get install -y software-properties-common gcc-9 g++-9 \
      sudo git curl build-essential pkg-config bison flex autoconf \
      binutils-dev libevent-dev acl-dev libfmt-dev libjemalloc-dev libiberty-dev    \
      libdouble-conversion-dev liblz4-dev liblzma-dev libssl-dev libunwind-dev      \
      libboost-context-dev libboost-filesystem-dev libboost-program-options-dev     \
      libboost-regex-dev libboost-system-dev libboost-thread-dev libdwarf-dev       \
      libelf-dev libfuse-dev libgoogle-glog-dev libffi-dev libgdbm-dev libyaml-dev  \
      libncurses-dev libreadline-dev clang ruby-dev ruby-bundler postgresql postgresql-contrib && apt-get clean && \
      rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN curl https://apt.kitware.com/kitware-archive.sh | bash
RUN apt-get install -y cmake && apt-get clean && \
      rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN gem install tebako
ENV CC=gcc
ENV CXX=g++
RUN cmake --version
WORKDIR /app
RUN tebako setup -p=output/3.2.2 -R=3.2.2
# ENTRYPOINT [ "/bin/bash", "-c" ]
# CMD [ "tebako" ]

COPY examples/pact /app/examples/pact
RUN apt-get update -y && apt-get install -y libpq-dev && apt-get clean && \
      rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN tebako press -p=output/3.2.2 -R 3.2.2 --root=examples/pact --entry-point=app --output=pact-cli-3.2.2
ENTRYPOINT [ "/app/pact-cli-3.2.2" ]
# CMD [ "tebako" ]


# FROM ubuntu:10.04
# COPY --from=stage1 /app/pact-cli-3.2.2 /usr/local/bin/pact-cli
# RUN /usr/local/bin/pact-cli broker version
# ENTRYPOINT [ "pact-cli" ]
# FROM ubuntu:12.04
# COPY --from=stage1 /app/pact-cli-3.2.2 /usr/local/bin/pact-cli
# RUN pact-cli broker version
# ENTRYPOINT [ "pact-cli" ]
# FROM ubuntu:14.04
# COPY --from=stage1 /app/pact-cli-3.2.2 /usr/local/bin/pact-cli
# RUN pact-cli broker version && echo foo
# ENTRYPOINT [ "pact-cli" ]
# FROM ubuntu:16.04
# COPY --from=stage1 /app/pact-cli-3.2.2 /usr/local/bin/pact-cli
# RUN pact-cli broker version && echo foo
# ENTRYPOINT [ "pact-cli" ]
# FROM ubuntu:18.04
# COPY --from=stage1 /app/pact-cli-3.2.2 /usr/local/bin/pact-cli
# RUN pact-cli broker version && echo foo
# ENTRYPOINT [ "pact-cli" ]
# FROM centos:8
# COPY --from=stage1 /app/pact-cli-3.2.2 /usr/local/bin/pact-cli
# RUN pact-cli broker version && echo foo
# ENTRYPOINT [ "pact-cli" ]
# FROM ubuntu:22.04
# COPY --from=stage1 /app/pact-cli-3.2.2 /usr/local/bin/pact-cli
# RUN pact-cli broker version
# ENTRYPOINT [ "pact-cli" ]
# FROM ubuntu:23.04
# COPY --from=stage1 /app/pact-cli-3.2.2 /usr/local/bin/pact-cli
# RUN pact-cli broker version
# ENTRYPOINT [ "pact-cli" ]
# FROM ubuntu:23.10
# COPY --from=stage1 /app/pact-cli-3.2.2 /usr/local/bin/pact-cli
# RUN pact-cli broker version
# ENTRYPOINT [ "pact-cli" ]
