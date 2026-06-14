ARG NODE_VERSION=24-alpine
FROM node:${NODE_VERSION}
LABEL author="Mukul Jariyal" \
      maintainer="Mukul Jariyal <mjtech009@gmail.com>" \
      description="Node.js golden base image (no Vault integration)"
RUN apk add --no-cache \
        ca-certificates \
        curl \
        tini \
        bash \
        bind-tools \
        busybox-extras
RUN mkdir -p /app \
    && chown -R node:node /app
WORKDIR /app
COPY --chown=node:node entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 755 /usr/local/bin/entrypoint.sh
ENV NODE_ENV=production \
    NODE_OPTIONS="--max-old-space-size=1536 --max-http-header-size=16384" \
    UV_THREADPOOL_SIZE=8 \
    NPM_CONFIG_LOGLEVEL=warn
USER node
ENTRYPOINT ["tini", "--", "/usr/local/bin/entrypoint.sh"]