# Contributing Guide

Thank you for contributing to ADAMANT wallet metadata. This repository is used by ADAMANT apps, so metadata changes should be small, reviewed carefully, and validated before submission.

- [Pull Request Guidelines](#pull-request-guidelines)
- [Metadata Guidelines](#metadata-guidelines)
- [Development Setup](#development-setup)
- [Validation](#validation)
- [Project Structure](#project-structure)

## Pull Request Guidelines

- Target the `dev` branch. The `master` branch is a snapshot of the latest stable release.
- Create a focused topic branch from `dev`
- Keep unrelated metadata, documentation, and dependency changes in separate PRs when possible
- Use clear PR titles such as `Docs: Update metadata guidelines` or `Chore: Update ADM node endpoints`
- Link related issues in the PR body. Use closing keywords only when the PR fully resolves the issue
- Use the organization PR template from [Adamant-im/.github](https://github.com/Adamant-im/.github/blob/master/PULL_REQUEST_TEMPLATE.md)
- Multiple small commits are acceptable while the PR is in progress; GitHub can squash them before merging

If you add a feature or new metadata field:

- Explain why downstream apps need it
- Update `README.md` and `specification/openapi.json` when the metadata shape changes
- Add or update examples where they help reviewers understand the intended behavior

If you fix a bug:

- Describe the bug and its wallet-facing effect
- Link the issue or discussion when available
- Add validation evidence to the PR description

## Metadata Guidelines

- Treat `assets/general/*` as shared metadata and `assets/blockchains/*` as blockchain defaults or token-specific overrides
- Preserve endpoint diversity for nodes and services
- Keep valid `alt_ip` fallbacks when editing availability-sensitive endpoints
- Do not introduce placeholder URLs, guessed contract IDs, or unverified blockchain values
- Be careful with wallet-visible precision and fees: `decimals`, `cryptoTransferDecimals`, `minBalance`, `minTransferAmount`, `fixedFee`, `defaultFee`, gas defaults, and reliability percentages
- Be careful with downstream behavior fields: `regexAddress`, explorer URL placeholders, `txFetchInfo`, `txConsistencyMaxTime`, `timeout`, `status`, `createCoin`, `defaultVisibility`, and `defaultOrdinalLevel`
- Keep icon filenames and required variants aligned with `README.md`

## Development Setup

Use Node.js `>=22.22.1` and [pnpm](https://pnpm.io/).

After cloning the repository, install dependencies:

```bash
pnpm install
```

When doing dependency security work, install without lifecycle scripts first:

```bash
pnpm install --ignore-scripts
```

Only run trusted lifecycle scripts after reviewing the package metadata and the reason the script is needed.

## Validation

Run the checks that match your change:

```bash
pnpm run validate
```

For targeted formatting checks:

```bash
pnpm exec prettier --check <changed-files>
```

For JSON-only validation:

```bash
pnpm run validate:json
```

If the change affects schemas or field semantics, verify that `README.md`, `specification/openapi.json`, and the edited assets stay aligned.

## Project Structure

See [README.md](../README.md) for the repository structure, metadata model, and field descriptions.
