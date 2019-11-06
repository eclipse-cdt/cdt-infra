FROM cdt-infra-eclipse-full:ubuntu-18.04

USER root
#Eclipse SDK & Fix permissions for OpenShift & standard k8s
RUN mkdir -p ${HOME}/buildtools && cd ${HOME}/buildtools \
  && curl -sL https://download.eclipse.org/eclipse/downloads/drops4/R-4.13-201909161045/eclipse-SDK-4.13-linux-gtk-x86_64.tar.gz | tar xvz \
  && mv eclipse eclipse-SDK-4.13 \
  && chown -R 1000:0 ${HOME} \
  && chmod -R g+rwX ${HOME}

RUN apt-get update && apt-get install -y --no-install-recommends \
      locales \
    && rm -rf /var/lib/apt/lists/*
RUN locale-gen en_US.UTF-8
# Need locale to be UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

USER 1000

CMD ["/home/vnc/.vnc/xstartup.sh"]
