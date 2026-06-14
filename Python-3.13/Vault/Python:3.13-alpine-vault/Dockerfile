ARG PYTHON_VERSION=3.13-alpine
FROM python:${PYTHON_VERSION}
LABEL author="Mukul Jariyal" \
      maintainer="Mukul Jariyal <mjtech009@gmail.com>" \
      description="Python 3.13 FastAPI golden base image with HashiCorp Vault integration"

ARG VAULT_VERSION=2.0.2
ARG TARGETARCH=amd64

# Build deps only needed to compile uvicorn C extensions (uvloop, httptools)
RUN apk add --no-cache --virtual .build-deps \
        gcc \
        musl-dev \
        libffi-dev \
    && pip install --no-cache-dir \
        "uvicorn[standard]==0.32.1" \
    && apk del .build-deps \
    && apk add --no-cache \
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
    && vault --version

RUN addgroup -S appuser \
    && adduser -S -G appuser appuser \
    && mkdir -p /app /home/appuser/.vault.d \
    && chown -R appuser:appuser /app /home/appuser

WORKDIR /app

COPY --chown=appuser:appuser entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 755 /usr/local/bin/entrypoint.sh

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONFAULTHANDLER=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

USER appuser

ENTRYPOINT ["tini", "--", "/usr/local/bin/entrypoint.sh"]
