FROM cdt-infra-base:ubuntu-16.04

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
      build-essential \
      gdb \
      libexpat1-dev \
      #libipt1 \ Ubuntu 18.04
      libmpfr-dev \
      libncurses-dev \
      ninja-build \
      pkg-config \
      python3-all-dev python3-pip python3-setuptools \
      zlib1g-dev \
      gdbserver \
    && rm -rf /var/lib/apt/lists/* \
    && pip3 install --upgrade pip

#Specifc CDT deps

#Meson
RUN pip3 install meson

#Node
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*  \
    && npm install -g yarn

# GDB pre-built in a different image
COPY --from=cdt-infra-all-gdbs:ubuntu-16.04 /shared/common/gdb/gdb-all /shared/common/gdb/gdb-all

#Fix permissions for OpenShift & standard k8s
RUN chown -R 1000:0 /home/cdt \
  && chmod -R g+rwX /home/cdt

USER 1000
