FROM cdt-infra-base:ubuntu-18.04

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
      build-essential \
      gdb \
      libexpat1-dev \
      libipt1 \
      libmpfr-dev \
      libncurses-dev \
      ninja-build \
      pkg-config \
      python3-all-dev python3-pip python3-setuptools \
      zlib1g-dev \
      gdbserver \
      gcc-mingw-w64-x86-64 \
      clang \
      libxml2-utils \
      gettext-base \
      xserver-xephyr \
    && apt-get install -y llvm \
    && apt-get install -y --no-install-recommends texinfo bison flex \
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
COPY --from=cdt-infra-all-gdbs:ubuntu-18.04 /shared/common/gdb/gdb-all /shared/common/gdb/gdb-all
ENV PATH="/shared/common/gdb/gdb-all/bin:${PATH}"

# Get header files for win32 & mac for cross compiling JNI libraries
RUN mkdir /tmp/x \
    && curl -sL https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u222-b10/OpenJDK8U-jdk_x64_windows_hotspot_8u222b10.zip > /tmp/x/openjdk-win32.zip \
    && curl -sL https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u222-b10/OpenJDK8U-jdk_x64_mac_hotspot_8u222b10.tar.gz > /tmp/x/openjdk-mac.zip \
    && mkdir /tmp/x/win32 && cd /tmp/x/win32 && unzip /tmp/x/openjdk-win32.zip \
    && mkdir /tmp/x/mac && cd /tmp/x/mac && tar xvf /tmp/x/openjdk-mac.zip \
    && cd $JAVA_HOME/include && for i in *.h; do diff $i /tmp/x/win32/jdk8u222-b10/include/$i ; done \
    && cd $JAVA_HOME/include && for i in *.h; do diff $i /tmp/x/mac/jdk8u222-b10/Contents/Home/include/$i ; done \
    && mv /tmp/x/win32/jdk8u222-b10/include/win32 $JAVA_HOME/include \
    && mv /tmp/x/mac/jdk8u222-b10/Contents/Home/include/darwin $JAVA_HOME/include \
    && find $JAVA_HOME/include \
    && rm -rf /tmp/x

# Get pre-built MacOSX toolchain from other image (this also 
# requires clang to be listed in the installs above)
COPY --from=cdt-infra-build-macos-sdk:ubuntu-18.04 /opt/osxcross/target /opt/osxcross/target
ENV PATH="/opt/osxcross/target/bin:${PATH}"

#Fix permissions for OpenShift & standard k8s
RUN chown -R 1000:0 ${HOME} \
  && chmod -R g+rwX ${HOME}


ENV USER_NAME vnc
USER 1000
WORKDIR ${HOME}

CMD ["/home/vnc/.vnc/xstartup.sh"]
