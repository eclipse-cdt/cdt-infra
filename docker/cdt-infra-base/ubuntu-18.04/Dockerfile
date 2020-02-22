# This file is derived from:
# - https://github.com/eclipse-cbi/dockerfiles/blob/bf1f1a18f4910d007de67765f8df083102150a7c/distros/Dockerfile
# - https://github.com/eclipse-cbi/dockerfiles/blob/bf1f1a18f4910d007de67765f8df083102150a7c/gtk3-wm/ubuntu-metacity/18.04/Dockerfile
# Consult https://github.com/eclipse-cbi/dockerfiles for possible updates
# differences from source are commented
FROM ubuntu:18.04

### user name recognition at runtime w/ an arbitrary uid - for OpenShift deployments
COPY scripts/uid_entrypoint /usr/local/bin/uid_entrypoint
RUN chmod u+x /usr/local/bin/uid_entrypoint && \
    chgrp 0 /usr/local/bin/uid_entrypoint && \
    chmod g=u /usr/local/bin/uid_entrypoint /etc/passwd
ENTRYPOINT [ "uid_entrypoint" ]

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
      libgtk-3-0 \
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
COPY scripts/xstartup_metacity.sh ${HOME}/.vnc/xstartup.sh
RUN chmod 755 ${HOME}/.vnc/xstartup*.sh

####
# From this point forward is the extra standard tools for CDT

# Java, git and other tools

RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates \
      openjdk-8-jdk \
      curl \
      openssh-client \
      wget \
      zip \
      unzip \
      gnupg \
      locales \
    && rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8
# Need locale to be UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

# The version of git in Ubuntu 18.04 causes problems, so use newer git. See Bug 548519
RUN echo "deb http://ppa.launchpad.net/git-core/ppa/ubuntu bionic main" > /etc/apt/sources.list.d/git-core-ubuntu-ppa-bionic.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E1DD270288B4E6030699E45FA1715D88E1DF1F24 
RUN apt-get update && apt-get install -y --no-install-recommends \
      git \
    && rm -rf /var/lib/apt/lists/*


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
