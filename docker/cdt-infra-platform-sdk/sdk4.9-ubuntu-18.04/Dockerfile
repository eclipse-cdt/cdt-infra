FROM cdt-infra-base:ubuntu-18.04

USER root
#Eclipse SDK
ENV ECLIPSE_VERSION 4.9
RUN mkdir -p ${HOME}/buildtools && cd ${HOME}/buildtools \
  && curl -sL https://download.eclipse.org/eclipse/downloads/drops4/R-4.9-201809060745/eclipse-SDK-4.9-linux-gtk-x86_64.tar.gz | tar xvz \
  && mv eclipse eclipse-SDK-${ECLIPSE_VERSION}

#Fix permissions for OpenShift & standard k8s
RUN chown -R 1000:0 ${HOME} \
  && chmod -R g+rwX ${HOME}

USER 1000

CMD ["/home/vnc/.vnc/xstartup.sh"]
