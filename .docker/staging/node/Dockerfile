FROM node:18

ARG UID
ARG GID

ENV DEBIAN_FRONTEND noninteractive
ENV TERM            xterm-color

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    sudo \
    curl \
    openssl \
    nano \
    locales \
    tzdata \
    dos2unix \
    zip \
    unzip \
    git

RUN usermod -aG sudo node && \
    echo "node ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN usermod -u ${UID} -s /bin/bash node && groupmod -g ${GID} node

# Define locale PT-BR
RUN echo "pt_BR.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen "pt_BR.UTF-8" && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG="pt_BR.UTF-8"

# Define Timezone America/Sao_Paulo
RUN ln -fs /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

RUN npm install -g npm@9.6.1

RUN npm install --global pm2

ADD .docker/staging/node/bin/* /docker/

RUN chmod +x /docker/entrypoint.sh

RUN mkdir -p /var/www/ && \
    chown -R node:node /var/www/

USER node

ENTRYPOINT ["/docker/entrypoint.sh"]
