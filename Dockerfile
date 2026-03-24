# syntax=docker/dockerfile:1

FROM debian:stable-slim

RUN apt-get update && \
    apt-get install -y curl sudo libncurses6

ARG USER_NAME=user
ARG GROUP_NAME=user
ARG UID=1000
ARG GID=1000
RUN groupadd -g $GID $GROUP_NAME && \
    useradd -l -u $UID -m -g $GID -G sudo -s /bin/bash $USER_NAME && \
    echo "$USER_NAME    ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER $USER_NAME
WORKDIR /home/$USER_NAME/

# Set to 1 to use Swift 5.6.1 toolchain and iPhoneOS15.6 SDK (supports armv7 / armv7s)
ARG LEGACY_SWIFT=0
RUN curl -fsSL https://raw.githubusercontent.com/theos/theos/master/bin/install-theos -o /tmp/install-theos.sh && \
    if [ "$LEGACY_SWIFT" = "1" ]; then \
      sed -i -E "s|swift-toolchain-linux/releases/download/v[^/]+/swift-[0-9][0-9.]*-|swift-toolchain-linux/releases/download/v2.1.0/swift-5.6.1-|g; s|bin/install-sdk latest([^-])|bin/install-sdk iPhoneOS15.6\1|g" /tmp/install-theos.sh; \
    fi && \
    yes y | bash /tmp/install-theos.sh && \
    rm /tmp/install-theos.sh

ENV THEOS /home/$USER_NAME/theos
ENV PATH $PATH:$THEOS/bin
# Debian stable no longer ships ld.gold; Theos toolchain's clang requires it
RUN sudo ln -s /usr/bin/ld.bfd /usr/bin/ld.gold

RUN echo 'alias theos="$THEOS/bin/nic.pl"' >> ~/.bashrc && \
    sudo apt-get clean && \
    sudo rm -rf /var/lib/apt/lists/*
