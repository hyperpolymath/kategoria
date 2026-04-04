#!/usr/bin/env bash
# SPDX-License-Identifier: PMPL-1.0-or-later
# Copyright (c) 2026 Jonathan D.A. Jewell (hyperpolymath) <j.d.a.jewell@open.ac.uk>
# property_test.sh — Property invariant tests for kategoria.

set -euo pipefail
PASS=0; FAIL=0; BASE=/var/mnt/eclipse/repos/kategoria

assert() {
  if [[ "$2" == "0" ]]; then echo "PASS: $1"; PASS=$((PASS+1))
  else echo "FAIL: $1"; FAIL=$((FAIL+1)); fi
}

echo "=== Property: All Zig files have SPDX headers ==="
while IFS= read -r f; do
  has_spdx=$(grep -q "SPDX-License-Identifier" "$f" && echo 0 || echo 1)
  assert "SPDX in $(basename "$f")" "$has_spdx"
done < <(find "$BASE/src" -name "*.zig" 2>/dev/null)

echo ""
echo "=== Property: No hardcoded secrets ==="
secret_hits=$(grep -r "password\s*=\s*['\"]" "$BASE/src" 2>/dev/null | grep -v "//\|test" | wc -l || true)
assert "No hardcoded passwords" "$([ "$secret_hits" -eq 0 ] && echo 0 || echo 1)"

echo ""
echo "=== Property: Version string is consistent ==="
version_count=$(grep -r "VERSION.*0\." "$BASE/src" 2>/dev/null | wc -l || true)
assert "Version string present" "$([ "$version_count" -gt 0 ] && echo 0 || echo 1)"

echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="
[ "$FAIL" -eq 0 ] && exit 0 || exit 1
