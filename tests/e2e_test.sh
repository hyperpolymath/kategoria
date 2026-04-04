#!/usr/bin/env bash
# SPDX-License-Identifier: PMPL-1.0-or-later
# Copyright (c) 2026 Jonathan D.A. Jewell (hyperpolymath) <j.d.a.jewell@open.ac.uk>
#
# e2e_test.sh — Structural and E2E tests for kategoria.
# Validates repository structure, ABI/FFI consistency, and test coverage.

set -euo pipefail

PASS=0; FAIL=0; BASE=/var/mnt/eclipse/repos/kategoria

assert() {
  if [[ "$2" == "0" ]]; then echo "PASS: $1"; PASS=$((PASS+1))
  else echo "FAIL: $1"; FAIL=$((FAIL+1)); fi
}

echo "=== E2E: Repository Structure ==="
for d in src tests ffi; do
  assert "$d directory exists" "$([ -d "$BASE/$d" ] && echo 0 || echo 1)"
done
assert "AI manifest exists" "$([ -f "$BASE/0-AI-MANIFEST.a2ml" ] && echo 0 || echo 1)"

echo ""
echo "=== E2E: ABI/FFI Consistency ==="
assert "Zig FFI source exists" "$([ -f "$BASE/src/interface/ffi/src/main.zig" ] && echo 0 || echo 1)"
assert "Zig integration test exists" "$([ -f "$BASE/src/interface/ffi/test/integration_test.zig" ] && echo 0 || echo 1)"
assert "Zig build file exists" "$(find "$BASE/src/interface/ffi" -name "build.zig" 2>/dev/null | wc -l | grep -q "^[1-9]" && echo 0 || echo 1)"

echo ""
echo "=== E2E: Code Quality ==="
zig_files=$(find "$BASE/src" -name "*.zig" 2>/dev/null | wc -l)
assert "Zig source files present ($zig_files)" "$([ "$zig_files" -gt 0 ] && echo 0 || echo 1)"
spdx_count=$(find "$BASE/src" -name "*.zig" 2>/dev/null | xargs grep -l "SPDX-License-Identifier" 2>/dev/null | wc -l)
assert "Zig files have SPDX headers ($spdx_count/$zig_files)" "$([ "$spdx_count" -ge "$zig_files" ] && echo 0 || echo 1)"

echo ""
echo "=== E2E: Documentation ==="
for f in README.adoc LICENSE TEST-NEEDS.md; do
  assert "$f exists" "$([ -f "$BASE/$f" ] && echo 0 || echo 1)"
done

echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="
[ "$FAIL" -eq 0 ] && exit 0 || exit 1
