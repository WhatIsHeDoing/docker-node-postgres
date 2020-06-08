# docker-node-postgres

[![Docker Pulls](https://img.shields.io/docker/pulls/whatishedoing/docker-node-postgres?style=for-the-badge)][site]
[![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/whatishedoing/docker-node-postgres?style=for-the-badge)][site]

## 👋 Introduction

Designed to be used as a slim [Docker] base **serve-only** image for [Node.js], with libraries for
[PostgreSQL] connectivity. [Yarn] is also available.

## 🏃‍♀️ Usage

Here is how you could use a multi-stage Dockerfile to build a deployment package with a larger
image, then serve the output with `docker-node-postgres`:

```dockerfile
# 🐳 This is a multi-stage container.
# https://docs.docker.com/develop/develop-images/multistage-build/
# https://github.com/nodejs/docker-node/blob/master/docs/BestPractices.md
# https://nodejs.org/en/docs/guides/nodejs-docker-webapp/

# 👷🏿 First, build and test the source code.
FROM whatishedoing/aws-codebuild-node-postgresql:latest AS build

WORKDIR /build

# Copy all required files into the container.
COPY . .

RUN yarn install --frozen-lockfile

ENV ci true

RUN yarn ci && rm -rf node_modules

# 🚀 Now copy and run the output.
FROM whatishedoing/docker-node-postgres:latest as serve

WORKDIR /app

# Copy only the compiled output and minimum required files from the previous build stage.
# https://cloud.google.com/blog/products/gcp/kubernetes-best-practices-how-and-why-to-build-small-container-images
COPY --from=build \
    /build/dist \
    ./

ENV NODE_ENV production

# Only install production dependencies and clear the yarn cache.
# Auto-clean is run as part of the install.
RUN yarn install --cache-folder ./ycache --frozen-lockfile --production && \
    rm -rf ./ycache

# Finally, expose the port and command to run the API.
EXPOSE 4000

# Run as a non-root user.
# https://github.com/goldbergyoni/nodebestpractices/blob/security-best-practices-section/sections/security/non-root-user.md
USER node

CMD ["node", "index.js"]
```

## 🧪 Testing

Assuming you have Docker installed, simply run:

```sh
docker build -t docker-node-postgres .
```

[docker]: https://www.docker.com/
[node.js]: https://nodejs.org/
[postgresql]: https://www.postgresql.org/
[site]: https://hub.docker.com/r/whatishedoing/docker-node-postgres
[yarn]: https://yarnpkg.com/
