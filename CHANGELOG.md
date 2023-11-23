# Changelog

All notable changes to this project will be documented in this file.

## [2.1.0] - 2023-11-02

- Flux listing with ordinal level 90. 
- Swarm listing with ordinal level 95.

## [2.0.0] - 2023-10-24

### Added

- SCALE coin to the main tokens list with ordinal level 94.

- Minimal supported node API version

  ```json5
  {
    "minNodeVersion": "0.8.0", // Optional.
    // ...
  }
  ```

- Tor nodes

  ```json5
  {
    // Optional. Tor configuration if a project uses Tor
    // It follows the same structure as the root properties
    // Currently supported props are described below:
    "tor": {
      "website": "http://abc.onion",
      "explorer": "http://xyz.onion",
      "explorerTx": "http://xyz.onion/tx/${ID}",
      "explorerAddress": "http://xyz.onion/address/${ID}",
      "nodes": [/*...*/],
      "services": {/*...*/},
      "links": [/*...*/]
    }
  }
  ```


### Changed

- `services` have been replaced with `serviceNodes`.

  Before:

  ```json5
  {
    "serviceNodes": [
      { "url": "https://example.com" }
    ]
  }
  ```

  After:

  ```json5
  {
    "services": {
      "infoService": [ // Optional.
        { "url": "https://example.com" }
      ],
      "lskService": [ // Optional.
        { "url": "https://example.com" }
      ],
      // Other possible services...
    }
  }
  ```
