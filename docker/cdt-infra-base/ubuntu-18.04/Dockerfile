# This file is derived from https://github.com/eclipse-cbi/dockerfiles/blob/d35a1ccdc3c1ac5b2faf2495605ab34c96d0c1a1/ubuntu-gtk3-metacity/18.04-gtk3.22/Dockerfile
# Consult https://github.com/eclipse-cbi/dockerfiles/blob/master/ubuntu-gtk3-metacity/18.04-gtk3.22/Dockerfile for possible updates - differences
# from source are commented
FROM ubuntu:18.04

### user name recognition at runtime w/ an arbitrary uid - for OpenShift deployments
COPY scripts/uid_entrypoint /usr/local/bin/uid_entrypoint
RUN chmod u+x /usr/local/bin/uid_entrypoint && \
    chgrp 0 /usr/local/bin/uid_entrypoint && \
    chmod g=u /usr/local/bin/uid_entrypoint /etc/passwd
ENTRYPOINT [ "uid_entrypoint" ]

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
      libgtk-3-0=3.22.* \
      tigervnc-standalone-server \
      tigervnc-common \
      metacity \
      x11-xserver-utils \
      libgl1-mesa-dri \
      xfonts-base \
      xfonts-scalable \
      xfonts-100dpi \
      xfonts-75dpi \
      fonts-liberation \
      fonts-liberation2 \
      fonts-freefont-ttf \
      fonts-dejavu \
      fonts-dejavu-core \
      fonts-dejavu-extra \
      # In addition to metacity in upstream version, provide icewm and mutter managers
      dbus-x11 \
      mutter \
      icewm \
    && rm -rf /var/lib/apt/lists/*

ENV HOME=/home/vnc
ENV DISPLAY :0

RUN mkdir -p ${HOME}/.vnc && chmod -R 775 ${HOME} \
  && echo "123456" | vncpasswd -f > ${HOME}/.vnc/passwd \
  && chmod 600 ${HOME}/.vnc/passwd

# In addition to metacity in upstream version, provide icewm and mutter manager scripts
# and use icewm as default (experiments showed that on 16.04 metacity was more reliable,
# but on 18.04 icewm is more reliable when running tests)
COPY scripts/xstartup_*.sh ${HOME}/.vnc/
COPY scripts/xstartup_icewm.sh ${HOME}/.vnc/xstartup.sh
RUN chmod 755 ${HOME}/.vnc/xstartup*.sh

####
# From this point forward is the extra standard tools for CDT

# Java and other tools
RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates \
      openjdk-8-jdk \
      curl \
      wget \
      zip \
      unzip \
      git \
    && rm -rf /var/lib/apt/lists/*
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

# Maven
ENV MAVEN_VERSION 3.6.0
RUN curl -fsSL http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
  && mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn
ENV MAVEN_HOME /usr/share/maven


#Fix permissions for OpenShift & standard k8s
RUN chown -R 1000:0 ${HOME} \
  && chmod -R g+rwX ${HOME}

ENV USER_NAME vnc
USER 1000
WORKDIR ${HOME}
