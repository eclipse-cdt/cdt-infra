FROM cdt-infra-base:ubuntu-16.04

#Eclipse SDK
ENV ECLIPSE_VERSION 4.9
RUN mkdir -p ~/buildtools && cd ~/buildtools \
  && curl -sL https://download.eclipse.org/eclipse/downloads/drops4/R-4.9-201809060745/eclipse-SDK-4.9-linux-gtk-x86_64.tar.gz | tar xvz \
  && mv eclipse eclipse-SDK-${ECLIPSE_VERSION}
