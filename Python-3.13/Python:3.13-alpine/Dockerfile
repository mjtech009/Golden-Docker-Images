ARG PYTHON_VERSION=3.13-alpine
FROM python:${PYTHON_VERSION}
LABEL author="Mukul Jariyal" \
      maintainer="Mukul Jariyal <mjtech009@gmail.com>" \
      description="Python 3.13 FastAPI golden base image (no Vault integration)"

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
        tini \
        bash \
        bind-tools \
        busybox-extras

RUN addgroup -S appuser \
    && adduser -S -G appuser appuser \
    && mkdir -p /app \
    && chown -R appuser:appuser /app

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
