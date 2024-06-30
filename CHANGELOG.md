# Changelog

All notable changes to this project will be documented in this file.

## [2.5.0] - 2024-04-29

- Added new ADM nodes: `phecda.adm.im`, `tegmine.adm.im`, `tauri.adm.im`, `dschubba.adm.im`
- Removed `ethnode1.adamant.im`
- Updated FLOKI icon

## [2.4.0] - 2024-03-13

- Listed new token: FLOKI
- Fix defaultOrdinal level for GT, STORJ and XCN

## [2.3.0] - 2024-01-25

- Rollback full list of LSK nodes
- Added healtcheck constants
- Added `ethnode3.adamant.im`
- Listed new tokens: STORJ, GT

## [2.2.0] - 2023-12-19

- Updated ADM node version to `v0.8.0`
- Increased `defaultFee` to `0.00164` LSK
- Added `dashnode2`, `lisknode5` and `liskservice5`
- Removed temporarily `lisknode3`, `lisknode4`, `liskservice3` and `liskservice4` until v4 upgrade

## [2.1.0] - 2023-11-02

- Flux listing with ordinal level 90.
- Swarm listing with ordinal level 95.

## [2.0.1] - 2023-10-25

### Changed

- Updated ADAMANT `minNodeVersion` from `v0.7.0` to `v0.8.0`

## [2.0.0] - 2023-10-24

### Added

- SCALE coin to the main tokens list with ordinal level 94.

- Minimal supported node API version

  ```jsonc
  {
    "minNodeVersion": "0.8.0" // Optional.
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
      ]
    }
  }
  ```

### Changed

- `services` have been replaced with `serviceNodes`.

  Before:

  ```jsonc
  {
    "serviceNodes": [{ "url": "https://example.com" }]
  }
  ```

  After:

  ```jsonc
  {
    "services": {
      "infoService": [
        // Optional.
        { "url": "https://example.com" }
      ],
      "lskService": [
        // Optional.
        { "url": "https://example.com" }
      ]
      // Other possible services...
    }
  }
  ```
