<!-- SPDX-License-Identifier: MPL-2.0 -->
# Contributing

Thank you for your interest in contributing! We follow a "Dual-Track" architecture where human-readable documentation lives in the root and machine-readable policies live in `.machine_readable/`.

## How to Contribute

We welcome contributions in many forms:

- **Code:** Improving the core stack or extensions
- **Documentation:** Enhancing docs or AI manifests
- **Testing:** Adding property-based tests or formal proofs
- **Bug reports:** Filing clear, reproducible issues

## Contribution model — Tri-Perimeter Contribution Framework (TPCF)

kategoria follows the estate-wide **Tri-Perimeter Contribution Framework (TPCF)** — graduated trust without gatekeeping:

- **Perimeter 1 — Core Systems (maintainers only).** The proof kernel: the level-indexed routes (`routes/`), the soundness/metatheory modules, and the build/CI tooling. Direct commits by maintainers only (see `MAINTAINERS.adoc`).
- **Perimeter 2 — Expert Extensions (trusted contributors).** New proof routes, demos (`examples/`), and dependently-typed extensions. Apply via issue → review → merge, with every Idris module type-checking under `idris2 --check`.
- **Perimeter 3 — Community Sandbox (open to all).** Docs (`.adoc`), `.well-known/` content, AI manifests, and spec proposals.

### Fork workflow

External contributors use the standard **fork**-and-pull-request workflow: fork the repository, branch from `main`, run `just quality` (and `idris2 --check` on any touched proof module) locally, then open a PR. Maintainers (Perimeter 1) may commit directly to feature branches. Proof modules must type-check before review — a red Idris check blocks merge.

## Getting Started

1. **Read the AI Manifest:** Start with `0-AI-MANIFEST.a2ml` (if present) to understand the repository structure.
2. **Environment:** Use `nix develop` or `direnv allow` to set up your tools.
3. **Task Runner:** Use `just` to see available commands (`just --list`).

## Development Workflow

### Branch Naming

```
docs/short-description       # Documentation
test/what-added              # Test additions
feat/short-description       # New features
fix/issue-number-description # Bug fixes
refactor/what-changed        # Code improvements
security/what-fixed          # Security fixes
```

### Commit Messages

We follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

Types: `feat`, `fix`, `docs`, `test`, `refactor`, `ci`, `chore`, `security`

## Reporting Bugs

Before reporting:
1. Search existing issues
2. Check if it's already fixed in `main`

When reporting, include:
- Clear, descriptive title
- Environment details (OS, versions, toolchain)
- Steps to reproduce
- Expected vs actual behaviour

## Code of Conduct

All contributors are expected to adhere to our [Code of Conduct](CODE_OF_CONDUCT.md).

## License

By contributing, you agree that your contributions will be licensed under the same license as the project (see [LICENSE](LICENSE)).
