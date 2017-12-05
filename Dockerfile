FROM node:8-alpine

RUN apk add --no-cache chromium

ENV CHROME_BIN=/usr/bin/chromium-browser
ENV CHROME_PATH=/usr/lib/chromium/
