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
    && rm -rf /var/lib/apt/lists/* \
    && pip3 install --upgrade pip

#Specifc CDT deps
COPY scripts/download-build-gdb.sh /opt/scripts/download-build-gdb.sh
#GDB
ENV GDB_BASE /shared/common/gdb/gdb-all
ENV GDB_VERSIONS 8.2 8.1.1 8.0.1 7.12.1 7.11.1 7.10.1 7.9.1 7.8.2 7.7.1 7.6.2 7.5.1
RUN chmod u+x /opt/scripts/download-build-gdb.sh && mkdir -p /shared/common/gdb/gdb-all  && /opt/scripts/download-build-gdb.sh -b $GDB_BASE $GDB_VERSIONS \
    && rm -rf $GDB_BASE/download && rm -rf $GDB_BASE/build

#Meson
RUN pip3 install meson

#Node
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*  \
    && npm install -g yarn

#Fix permissions for OpenShift & standard k8s
RUN chown -R 1000:0 /home/cdt \
  && chmod -R g+rwX /home/cdt

USER 1000
