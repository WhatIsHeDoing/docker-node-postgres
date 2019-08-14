FROM node:lts-alpine

# Update, install PostGreSQL, Yarn and supporting packages, then clean up.
RUN apk update && \
    apk add jq postgresql postgresql-contrib yarn && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
