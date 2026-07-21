#!/usr/bin/env sh
# SPDX-License-Identifier: MPL-2.0
# Copyright (c) 2026 Jonathan D.A. Jewell (hyperpolymath) <j.d.a.jewell@open.ac.uk>
#
# check-idris2-proofs.sh — the proof gate for kategoria's verified modules.
#
# HARD-FAIL DESIGN: this script exits non-zero when idris2 is missing.
# A proof gate that silently passes without its prover is not a gate.
#
# Checks (matches the reproduce recipe in PROOF-STATUS.adoc):
#   1. Every module in examples/ and routes/alpha-extend/ passes
#      `idris2 --check` — no exceptions, no skips.
#   2. No axiom smuggling: postulate / believe_me / assert_total / %hint
#      may appear in comments (explaining why they were avoided) but
#      never in live code.

set -u

if ! command -v idris2 >/dev/null 2>&1; then
    echo "FATAL: idris2 not found on PATH - refusing to skip proof checking." >&2
    echo "Install Idris 2 (0.7.0 per PROOF-STATUS.adoc) and re-run." >&2
    exit 1
fi

echo "prover: $(idris2 --version)"

pass=0
fail=0

for f in examples/*.idr routes/alpha-extend/*.idr; do
    [ -f "$f" ] || continue
    dir=$(dirname "$f")
    base=$(basename "$f")
    if (cd "$dir" && idris2 --check "$base" >/dev/null 2>&1); then
        pass=$((pass+1))
        printf 'PASS %s\n' "$f"
    else
        fail=$((fail+1))
        printf 'FAIL %s\n' "$f"
        (cd "$dir" && idris2 --check "$base" 2>&1 | head -12)
    fi
done

# Axiom-smuggling scan. Strip `--` line comments and `|||` doc lines
# first, so prose ABOUT the forbidden constructs does not trip the gate.
smuggled=$(
    for f in examples/*.idr routes/alpha-extend/*.idr; do
        [ -f "$f" ] || continue
        sed -e 's/--.*$//' -e '/^[[:space:]]*|||/d' "$f" \
            | grep -nE '(^|[^A-Za-z_])(postulate|believe_me|assert_total)([^A-Za-z_]|$)|%hint' \
            | sed "s|^|$f:|"
    done
)
if [ -n "$smuggled" ]; then
    echo "FATAL: axiom smuggling detected outside comments:" >&2
    echo "$smuggled" >&2
    exit 1
fi

echo "proof-check: PASS=$pass FAIL=$fail"
if [ "$fail" -ne 0 ] || [ "$pass" -eq 0 ]; then
    exit 1
fi
