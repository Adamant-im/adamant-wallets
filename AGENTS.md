# ADAMANT Wallet Metadata: AI Agent Operating Manual

This document defines how AI agents should work in this repository.

## Mission

`adamant-wallets` is the canonical wallet metadata and specification repository used by ADAMANT apps.

Agent output must optimize for:

1. Metadata correctness for wallet behavior and display
2. Reliability and decentralization of node and service definitions
3. Documentation and schema consistency for downstream consumers
4. Maintainability and contributor clarity

If a tradeoff is required, preserve metadata correctness and downstream compatibility first.

## Language Policy

- Developers may communicate with AI in any language
- All repository artifacts must be in English only
- Write docs, JSON values, PR text, issue text, and commit messages in English

## Sources of Truth

Use these sources when implementing or reviewing changes:

- This repository's [README.md](README.md), [.github/CONTRIBUTING.md](.github/CONTRIBUTING.md), current assets, and passing validation
- Shared metadata in `assets/general/*`
- Blockchain definitions and overrides in `assets/blockchains/*`
- OpenAPI schema in `specification/openapi.json`
- Org-wide issue and label governance in <https://github.com/Adamant-im/.github>
- Related ADAMANT repositories when wallet-facing behavior overlaps:
  - <https://github.com/Adamant-im/adamant>
  - <https://github.com/Adamant-im/adamant-console>
  - <https://github.com/Adamant-im/adamant-api-jsclient>

Repository-specific rule:

- If [README.md](README.md), the JSON assets, and `specification/openapi.json` disagree, treat the current JSON assets as implementation truth for current wallet metadata, then document and fix the drift.

## Repository Map

- `assets/general/<coin-or-token>/info.json`: shared coin or token metadata
- `assets/general/<coin-or-token>/images/`: wallet icons and Vue icon assets
- `assets/blockchains/<blockchain>/info.json`: blockchain-level metadata such as type, fee coin, and shared overrides
- `assets/blockchains/<blockchain>/<token>/info.json`: token overrides specific to a blockchain
- `specification/openapi.json`: schema describing wallet metadata objects
- [README.md](README.md): human-readable repository rules and field semantics
- [.github/CONTRIBUTING.md](.github/CONTRIBUTING.md): branch and PR workflow

## Metadata Invariants

Understand the override model before editing:

1. Shared metadata starts in `assets/general/*`
2. Blockchain-level defaults may override shared fields in `assets/blockchains/<blockchain>/info.json`
3. Token-specific blockchain overrides live in `assets/blockchains/<blockchain>/<token>/info.json`

Do not make silent semantic changes to any of the following without verifying downstream impact:

- `regexAddress`, explorer URLs, and `${ID}` placeholders
- `symbol`, `decimals`, `cryptoTransferDecimals`, `minBalance`, `minTransferAmount`
- `fixedFee`, `defaultFee`, gas defaults, reliability gas percentages, and warning thresholds
- `txFetchInfo`, `txConsistencyMaxTime`, and `timeout`
- `nodes`, `services`, `healthCheck`, `minVersion`, `nodeTimeCorrection`, `alt_ip`, and `hasIndex`
- `testnet` and `tor` sections
- `status`, `createCoin`, `defaultVisibility`, and `defaultOrdinalLevel`
- icon filenames and required asset variants documented in [README.md](README.md)

## Safety and Reliability Rules

- Do not reduce node or service diversity without explicit justification
- Do not hardcode a single endpoint as the only viable path when a list-based configuration exists
- Keep `alt_ip` fallbacks valid when editing censored-domain or availability-sensitive endpoints
- Preserve wallet-visible precision and fee semantics unless the task explicitly changes them
- Treat changes to ADM and Ethereum metadata as high-impact because many downstream apps inherit from those definitions
- Do not introduce placeholder URLs, fake contract IDs, or guessed blockchain values

## Documentation Drift Policy

When metadata shape or semantics change:

1. Update the relevant JSON assets
2. Update [README.md](README.md) if field meaning or workflow changed
3. Update `specification/openapi.json` if the schema changed
4. If synchronized updates cannot be completed now, create or link a follow-up issue and describe the drift clearly

## Issue, Label, and PR Conventions

When creating issues:

1. Search existing issues first: <https://github.com/Adamant-im/adamant-wallets/issues>
2. Use org templates from `Adamant-im/.github/.github/ISSUE_TEMPLATE/*`
3. Start the title with one concise prefix
4. Apply labels from the org label catalog
5. Link related issues and PRs explicitly

Recommended issue title prefixes:

- `[Bug]`
- `[Feat]`
- `[Enhancement]`
- `[Refactor]`
- `[Docs]`
- `[Test]`
- `[Chore]`
- `[Task]`
- `[Composite]`

Label policy:

- Use a minimal but informative set
- Prefer one type label and one or more domain labels such as `documentation`, `Guideline`, `Infrastructure`, `Nodes`, `APIs`, or `Cryptocurrency`
- Keep label casing aligned with this repository

PR policy:

- Target `dev`, not `master`
- Use `Type: Short summary` titles such as `Docs: Add AGENTS.md`
- Do not use issue-style square-bracket prefixes in PR titles
- Link issues in the PR body with closing keywords when applicable, for example `Closes #131`
- Use a temporary file in `.ai-ignored/` for multi-line PR and issue bodies

## Validation Expectations

Baseline validation depends on the change type:

- Docs-only changes: verify links, structure, and repository-specific accuracy; say explicitly that runtime tests were not run
- `json`, `svg`, or `vue` changes: run `pnpm exec prettier --check <files>` or format the touched files before finalizing
- Schema-affecting changes: review both [README.md](README.md) and `specification/openapi.json` for alignment with the edited metadata

Never claim validation you did not run.

## Working Style

- Prefer focused patches over broad metadata churn
- Match existing naming, casing, and field ordering unless there is a strong reason to change them
- Keep changes easy to diff and review
- When editing endpoints or numeric parameters, confirm the surrounding object semantics before changing a single field
- Use temporary files in `.ai-ignored/` for multi-line CLI input such as `gh issue create --body-file` and `gh pr create --body-file`

## Done Criteria

A change is not complete until all of the following are true:

1. Repository artifacts are in English
2. The override model remains internally consistent
3. Relevant docs and schema files were updated or documented as follow-up work
4. Validation actually run was reported accurately
5. No avoidable single-point-of-failure or wallet-breaking metadata regression was introduced