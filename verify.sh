#!/usr/bin/env bash
# Check that all three nodes serve their own Ansible-configured page.
# Usage: ./verify.sh   (run after the playbook has completed)

set -u

pass=0
fail=0

for i in 1 2 3; do
    node="node${i}"
    port=$((8080 + i))
    body="$(curl -s --max-time 5 "http://127.0.0.1:${port}/" || true)"
    if printf '%s' "$body" | grep -q "served by ${node}"; then
        echo "PASS  ${node}  (http://127.0.0.1:${port}/)"
        pass=$((pass + 1))
    else
        echo "FAIL  ${node}  (http://127.0.0.1:${port}/)"
        fail=$((fail + 1))
    fi
done

echo "----"
echo "Passed: ${pass}/3   Failed: ${fail}/3"

[ "$fail" -eq 0 ]
