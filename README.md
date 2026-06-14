# Golden Docker Images

Secure, minimal, production-ready base images built and published via GitHub Actions to the GitHub Container Registry (GHCR).

## Images

| Image | Base | Description |
|-------|------|-------------|
| `node-24-alpine` | `node:24-alpine` | Node.js 24 — no extras |
| `node-24-alpine-vault` | `node:24-alpine` | Node.js 24 + HashiCorp Vault agent |
| `python-3.13-alpine` | `python:3.13-alpine` | Python 3.13 + uvicorn (FastAPI-ready) — no extras |
| `python-3.13-alpine-vault` | `python:3.13-alpine` | Python 3.13 + uvicorn + HashiCorp Vault agent |

## Registry

Images are published to GHCR on every push to `main`:

```
ghcr.io/<owner>/golden-docker-images/node-24-alpine:latest
ghcr.io/<owner>/golden-docker-images/node-24-alpine-vault:latest
ghcr.io/<owner>/golden-docker-images/python-3.13-alpine:latest
ghcr.io/<owner>/golden-docker-images/python-3.13-alpine-vault:latest
```

Tags: `latest` (main branch), short SHA (`abc1234`), `pr-<N>` (pull requests).

## Pipeline

Every image goes through the following stages before being pushed:

1. **Lint** — Hadolint checks Dockerfile best practices (gate: ERROR level)
2. **Build** — multi-arch build (`linux/amd64`, `linux/arm64`) via Docker Buildx
3. **Scan** — Trivy scans for CVEs across OS packages and libraries
4. **Gate** — pipeline fails on any fixable CRITICAL CVE
5. **SBOM** — SPDX + CycloneDX software bill of materials attached as artifacts
6. **Push** — signed image with build provenance attestation pushed to GHCR

## Usage

**Node.js**
```dockerfile
FROM ghcr.io/<owner>/golden-docker-images/node-24-alpine:latest

WORKDIR /app
COPY --chown=node:node . .
RUN npm ci --omit=dev
CMD ["node", "src/index.js"]
```

**Python / FastAPI**
```dockerfile
FROM ghcr.io/<owner>/golden-docker-images/python-3.13-alpine:latest

COPY --chown=appuser:appuser requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY --chown=appuser:appuser . .
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

## Adding a new image

1. Create a directory under an appropriate folder (e.g. `Node-24/MyVariant/`).
2. Add a `Dockerfile` and `entrypoint.sh`.
3. Add a `.dockerignore` that allowlists only `Dockerfile` and `entrypoint.sh`.
4. Add the new image to the matrix in [`.github/workflows/publish-image.yaml`](.github/workflows/publish-image.yaml).

## Security

- Non-root `node` user at runtime
- `tini` as PID 1 to handle signals and zombie reaping
- Trivy SARIF reports uploaded to the GitHub Security tab on every run
- Build provenance attestations signed via `actions/attest-build-provenance`
- Known accepted CVEs listed in [`.trivyignore`](.trivyignore)

## Maintainer

Mukul Jariyal — mjtech009@gmail.com
