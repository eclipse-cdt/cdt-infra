FROM ubuntu:16.04

USER root

### user name recognition at runtime w/ an arbitrary uid - for OpenShift deployments
COPY scripts/uid_entrypoint /usr/local/bin/uid_entrypoint
RUN chmod u+x /usr/local/bin/uid_entrypoint && \
    chgrp 0 /usr/local/bin/uid_entrypoint && \
    chmod g=u /usr/local/bin/uid_entrypoint /etc/passwd
#ENTRYPOINT [ "uid_entrypoint" ]
### end

RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      git \
      gnupg \
      openjdk-8-jdk \
      pkg-config \
      wget \
      zip \
      ##Xvnc
      libgtk-3-0 \
      locales \
      #libgtk-3-0=3.22.30-1ubuntu1 \ Ubuntu 18.04
      #tigervnc-standalone-server \ Ubuntu 18.04
      #tigervnc-common \ Ubuntu 18.04
      #metacity \
      icewm \
      x11-xserver-utils \
      libgl1-mesa-dri \
      xfonts-base \
      xfonts-scalable \
      xfonts-100dpi \
      xfonts-75dpi \
      fonts-liberation \
      #fonts-liberation2 \ Ubuntu 18.04
      fonts-freefont-ttf \
      fonts-dejavu \
      fonts-dejavu-core \
      fonts-dejavu-extra \
    && rm -rf /var/lib/apt/lists/* \
    && locale-gen en_US.UTF-8
# Need locale to be UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN [ -f "/etc/ssl/certs/java/cacerts" ] || /var/lib/dpkg/info/ca-certificates-java.postinst configure

RUN apt-get update && apt-get install -y --no-install-recommends x11-utils xauth  libtasn1-3-bin libxfont1-dev libglu1-mesa x11-xkb-utils \
    && rm -rf /var/lib/apt/lists/* && wget https://dl.bintray.com/tigervnc/stable/ubuntu-16.04LTS/amd64/tigervncserver_1.9.0-1ubuntu1_amd64.deb -O /tmp/tigervncserver_1.9.0-1ubuntu1_amd64.deb \
  && dpkg -i /tmp/tigervncserver_1.9.0-1ubuntu1_amd64.deb \
  && rm /tmp/tigervncserver_1.9.0-1ubuntu1_amd64.deb

ENV USER_NAME cdt
ENV HOME /home/cdt

# Setup VNC
ENV DISPLAY :0
RUN mkdir -p ${HOME}/.vnc && chmod -R 775 ${HOME} \
  && echo "123456" | vncpasswd -f > ${HOME}/.vnc/passwd \
  && chmod 600 ${HOME}/.vnc/passwd
# Create a custom vnc xstartup file
COPY scripts/xstartup_icewm.sh ${HOME}/.vnc/xstartup.sh
RUN chmod 755 ${HOME}/.vnc/xstartup.sh
ENTRYPOINT [ "uid_entrypoint" ]
CMD ["/home/cdt/.vnc/xstartup.sh"]

# Maven
ENV MAVEN_VERSION 3.6.0
RUN curl -fsSL http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
  && mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn
ENV MAVEN_HOME /usr/share/maven

#Fix permissions for OpenShift & standard k8s
RUN chown -R 1000:0 /home/cdt \
  && chmod -R g+rwX /home/cdt

USER 1000
WORKDIR /home/cdt
