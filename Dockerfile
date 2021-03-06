FROM node:lts-alpine

# Update, install PostgreSQL, Yarn and supporting packages, then clean up.
RUN apk update && \
    apk add postgresql postgresql-contrib yarn && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
