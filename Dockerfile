FROM ubuntu:latest

ENV NODE_VERSION=16.19.0

RUN apt update \
    && apt install -y curl git libgtk2.0-0 libgtk-3-0 libgbm-dev libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 libxtst6 xauth xvfb \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/app

# Copied from https://stackoverflow.com/a/57546198
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN node --version
RUN npm --version

RUN npm init -y

RUN npm install cypress

RUN npx cypress install

COPY cypress cypress
COPY cypress.config.js cypress.config.js

ENTRYPOINT [ "npx", "cypress", "run" ]
