#!/bin/sh
set -e

ulimit -n 65536 2>/dev/null || echo "WARN: could not raise 'nofile' soft limit (current: $(ulimit -n))"

ulimit -u 4096 2>/dev/null || echo "WARN: could not raise 'nproc' soft limit (current: $(ulimit -u))"

ulimit -c 0 2>/dev/null || true

echo "[entrypoint] ulimits -> nofile: $(ulimit -n), nproc: $(ulimit -u), core: $(ulimit -c)"
echo "[entrypoint] vault: $(vault --version 2>/dev/null | head -n1)"

exec "$@"