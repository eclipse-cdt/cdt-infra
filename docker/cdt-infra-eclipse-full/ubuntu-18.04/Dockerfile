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
      g++-mingw-w64-x86-64 \
      gcc-aarch64-linux-gnu \
      g++-aarch64-linux-gnu \
      gcc-powerpc-linux-gnu \
      g++-powerpc-linux-gnu \
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

# Get header files for win32 & mac for cross compiling JNI libraries on Java 8
ENV JDK8_VERSION=jdk8u252-b09
RUN mkdir /tmp/x \
    && curl -sL https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u252-b09.1/OpenJDK8U-jdk_x64_windows_hotspot_8u252b09.zip > /tmp/x/openjdk-win32.zip \
    && curl -sL https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u252-b09.1/OpenJDK8U-jdk_x64_mac_hotspot_8u252b09.tar.gz > /tmp/x/openjdk-mac.tar.gz \
    && mkdir /tmp/x/win32 && cd /tmp/x/win32 && unzip /tmp/x/openjdk-win32.zip \
    && mkdir /tmp/x/mac && cd /tmp/x/mac && tar xvf /tmp/x/openjdk-mac.tar.gz \
    && cd $JAVA8_HOME/include && for i in *.h; do diff $i /tmp/x/win32/${JDK8_VERSION}/include/$i ; done \
    && cd $JAVA8_HOME/include && for i in *.h; do diff $i /tmp/x/mac/${JDK8_VERSION}/Contents/Home/include/$i ; done \
    && mv /tmp/x/win32/${JDK8_VERSION}/include/win32 $JAVA8_HOME/include \
    && mv /tmp/x/mac/${JDK8_VERSION}/Contents/Home/include/darwin $JAVA8_HOME/include \
    && find $JAVA8_HOME/include \
    && rm -rf /tmp/x

# Get header files for win32 & mac for cross compiling JNI libraries on Java 11
ENV JDK11_VERSION=jdk-11.0.7+10
RUN mkdir /tmp/x \
    && curl -sL https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.7%2B10.2/OpenJDK11U-jdk_x64_windows_hotspot_11.0.7_10.zip > /tmp/x/openjdk-win32.zip \
    && curl -sL https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.7%2B10/OpenJDK11U-jdk_x64_mac_hotspot_11.0.7_10.tar.gz > /tmp/x/openjdk-mac.tar.gz \
    && mkdir /tmp/x/win32 && cd /tmp/x/win32 && unzip /tmp/x/openjdk-win32.zip \
    && mkdir /tmp/x/mac && cd /tmp/x/mac && tar xvf /tmp/x/openjdk-mac.tar.gz \
    && cd $JAVA11_HOME/include && for i in *.h; do diff $i /tmp/x/win32/${JDK11_VERSION}/include/$i ; done \
    && cd $JAVA11_HOME/include && for i in *.h; do diff $i /tmp/x/mac/${JDK11_VERSION}/Contents/Home/include/$i ; done \
    && mv /tmp/x/win32/${JDK11_VERSION}/include/win32 $JAVA11_HOME/include \
    && mv /tmp/x/mac/${JDK11_VERSION}/Contents/Home/include/darwin $JAVA11_HOME/include \
    && find $JAVA11_HOME/include \
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
