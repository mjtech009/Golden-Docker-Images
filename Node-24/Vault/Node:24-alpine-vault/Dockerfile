ARG NODE_VERSION=24-alpine
FROM node:${NODE_VERSION}
LABEL author="Mukul Jariyal" \
      maintainer="Mukul Jariyal <mjtech009@gmail.com>" \
      description="Node.js application with Vault integration for secure secret management"

ARG VAULT_VERSION=2.0.2
ARG TARGETARCH=amd64
RUN apk add --no-cache \
        ca-certificates \
        curl \
        unzip \
        tini \
        libcap \
        bash \
        bind-tools \
        busybox-extras \
    && case "${TARGETARCH}" in \
         amd64) VAULT_ARCH="amd64" ;; \
         arm64) VAULT_ARCH="arm64" ;; \
         *) VAULT_ARCH="amd64" ;; \
       esac \
    && curl -fsSL -o /tmp/vault.zip \
        "https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_${VAULT_ARCH}.zip" \
    && unzip -q /tmp/vault.zip -d /usr/local/bin \
    && rm -f /tmp/vault.zip \
    && chown root:root /usr/local/bin/vault \
    && chmod 0755 /usr/local/bin/vault \
    && vault --version \
    && su -s /bin/sh node -c 'vault --version'
RUN mkdir -p /home/node/.vault.d \
    && chown -R node:node /home/node

COPY --chown=node:node entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 755 /usr/local/bin/entrypoint.sh
ENV  NODE_OPTIONS="--max-old-space-size=1536 --max-http-header-size=16384" \
    UV_THREADPOOL_SIZE=8 \
    NPM_CONFIG_LOGLEVEL=warn
USER node
ENTRYPOINT ["tini", "--", "/usr/local/bin/entrypoint.sh"]