FROM node:22-bullseye-slim

ENV LANG en_US.UTF-8
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium
ENV CHROME_PATH=/usr/bin/chromium
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update -qq \
    && apt install -qq -y --no-install-recommends chromium \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /src/*.deb


COPY ./puppeteer ./app

WORKDIR /app

RUN npm install

CMD ["node", "app.js"]