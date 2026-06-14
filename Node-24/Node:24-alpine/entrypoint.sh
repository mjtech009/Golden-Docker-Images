#!/bin/sh
set -e
ulimit -n 65536 2>/dev/null || true
ulimit -u 4096 2>/dev/null || true
ulimit -c 0 2>/dev/null || true
echo "[entrypoint] ulimits -> nofile: $(ulimit -n), nproc: $(ulimit -u), core: $(ulimit -c)"
exec "$@"