# Changelog

All notable changes to this project will be documented in this file.

## [2.6.0] - 2026-06-27

### Added

- Added ADAMANT testnet metadata with dedicated testnet nodes, explorers, services, health checks, minimum API version, and node time correction
- Added service descriptions and endpoint groups for ADAMANT info services, IPFS nodes, Bitcoin indexers, Dogecoin indexers, and Ethereum indexers
- Added DOGE indexer metadata and Tor DOGE indexer endpoints
- Added Tor metadata for additional ADAMANT Currencyinfo services and node links
- Added `displayName` metadata for nodes and services
- Added `balanceCheckInterval`, `balanceCheckIntervalNewAccount`, and `balanceValidInterval` metadata and schema documentation
- Added message sending timeout metadata and schema documentation.
- Added `increasedGasPricePercent` metadata for higher-priority Bitcoin and Ethereum-like transfers
- Added Klayr metadata, nodes, services, and icons during the dev branch history
- Added ADAMANT AI agent operating instructions and markdownlint configuration

### Changed

- Updated ADAMANT, Bitcoin, Dogecoin, Ethereum, IPFS, and Currencyinfo node and service endpoint lists
- Updated alternative IP fallbacks for ADAMANT, Dogecoin, IPFS, and service endpoints
- Increased Ethereum `cryptoTransferDecimals` from `6` to `8`
- Increased service health check thresholds for IPFS and rates-info services
- Changed default visibility and ordinal levels for multiple assets, including ERC20 tokens
- Refined Bitcoin, Dogecoin, ADAMANT, Klayr, and service metadata structures to align with the current `services` object model
- Updated README and OpenAPI schema coverage for current wallet metadata fields

### Fixed

- Fixed DOGE address regex so it no longer accepts `|` as a valid first character
- Fixed the DAI GitHub link
- Fixed the Ethereum GT token override name
- Fixed Bitcoin explorer links and Tor Bitcoin node path metadata
- Fixed DOGE icon assets, including light mode and restored face variants
- Fixed MANA and Klayr icon assets
- Fixed service structure issues in Klayr Tor metadata
- Fixed missing `/api` path in Dogecoin indexer fallback metadata
- Fixed duplicate and incorrectly named ADAMANT testnet node metadata
- Fixed info service on-screen update interval metadata

### Removed

- Removed deprecated Stably USD (`USDS`) metadata and icon assets
- Removed unavailable `tauri.bbry.org`, `endless.bbry.org`, and `debate.bbry.org` ADM proxy nodes
- Removed Lisk metadata and support during the transition to Klayr
- Removed Klayr support later in the dev branch history
- Removed unavailable or deprecated ADAMANT, Bitcoin, Dogecoin, Ethereum, IPFS, Klayr, and proxy endpoints
- Removed deprecated IPFS Onion URL metadata

## [2.5.0] - 2024-04-29

- Added new ADM nodes: `phecda.adm.im`, `tegmine.adm.im`, `tauri.adm.im`, `dschubba.adm.im`
- Removed `ethnode1.adamant.im`
- Updated FLOKI icon

## [2.4.0] - 2024-03-13

- Listed new token: FLOKI
- Fixed `defaultOrdinalLevel` for GT, STORJ, and XCN

## [2.3.0] - 2024-01-25

- Rollback full list of LSK nodes
- Added health check constants
- Added `ethnode3.adamant.im`
- Listed new tokens: STORJ, GT

## [2.2.0] - 2023-12-19

- Updated ADM node version to `v0.8.0`
- Increased `defaultFee` to `0.00164` LSK
- Added `dashnode2`, `lisknode5` and `liskservice5`
- Removed temporarily `lisknode3`, `lisknode4`, `liskservice3` and `liskservice4` until v4 upgrade

## [2.1.0] - 2023-11-02

- Listed Flux with ordinal level 90
- Listed Swarm with ordinal level 95

## [2.0.1] - 2023-10-25

### Changed

- Updated ADAMANT `minNodeVersion` from `v0.7.0` to `v0.8.0`

## [2.0.0] - 2023-10-24

### Added

- SCALE coin to the main tokens list with ordinal level 94.

- Minimal supported node API version

  ```jsonc
  {
    "minNodeVersion": "0.8.0", // Optional.
    // ...
  }
  ```

- Tor nodes

  ```jsonc
  {
    // Optional. Tor configuration if a project uses Tor
    // It follows the same structure as the root properties
    // Currently supported props are described below:
    "tor": {
      "website": "http://abc.onion",
      "explorer": "http://xyz.onion",
      "explorerTx": "http://xyz.onion/tx/${ID}",
      "explorerAddress": "http://xyz.onion/address/${ID}",
      "nodes": [
        /*...*/
      ],
      "services": {
        /*...*/
      },
      "links": [
        /*...*/
      ],
    },
  }
  ```

### Changed

- `services` have been replaced with `serviceNodes`.

  Before:

  ```jsonc
  {
    "serviceNodes": [{ "url": "https://example.com" }],
  }
  ```

  After:

  ```jsonc
  {
    "services": {
      "infoService": [
        // Optional.
        { "url": "https://example.com" },
      ],
      "lskService": [
        // Optional.
        { "url": "https://example.com" },
      ],
      // Other possible services...
    },
  }
  ```
