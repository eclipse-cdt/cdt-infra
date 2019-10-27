# This dockerfile is used to build the MacOSX SDK
FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install -y clang make build-essential
RUN apt-get install -y libssl-dev lzma-dev liblzma-dev libxml2-dev git cmake patch python cpio bzip2 xz-utils

# Xcode_9.4.1.xip needs to be downloaded from 
# https://download.developer.apple.com/Developer_Tools/Xcode_9.4.1/Xcode_9.4.1.xip
ARG Xcodexip=Xcode_9.4.1.xip 
WORKDIR /opt
COPY ${Xcodexip} /opt/${Xcodexip}
RUN git clone https://github.com/tpoechtrager/osxcross.git
RUN cd /opt/osxcross && ./tools/gen_sdk_package_pbzx.sh /opt/${Xcodexip}
RUN mv /opt/osxcross/*.xz /opt/osxcross/tarballs
ENV UNATTENDED=1 
RUN cd /opt/osxcross && ./build.sh

# Start next stage build
FROM ubuntu:18.04
COPY --from=0 /opt/osxcross/target /opt/osxcross/target
ENV PATH="/opt/osxcross/target/bin:${PATH}"
# At this point the osxcross toolchain is not usable,
# it needs to be copied into another container and that
# container needs clang installed too.
