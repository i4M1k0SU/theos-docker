FROM debian:stable-slim

RUN apt-get update && \
    apt-get install -y curl sudo

ARG USER_NAME=user
ARG GROUP_NAME=user
ARG UID=1000
ARG GID=1000
RUN groupadd -g $GID $GROUP_NAME && \
    useradd -l -u $UID -m -g $GID -G sudo -s /bin/bash $USER_NAME && \
    echo "$USER_NAME    ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER $USER_NAME
WORKDIR /home/$USER_NAME/

RUN bash -c "yes y | $(curl -fsSL https://raw.githubusercontent.com/theos/theos/master/bin/install-theos)"

ENV THEOS /home/$USER_NAME/theos
ENV PATH $PATH:$THEOS/bin
RUN echo 'alias theos="$THEOS/bin/nic.pl"' >> ~/.bashrc && \
    sudo apt-get clean && \
    sudo rm -rf /var/lib/apt/lists/*
