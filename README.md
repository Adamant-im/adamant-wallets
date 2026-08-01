# ADAMANT wallet metadata

This repository contains canonical coin, token, blockchain, node, service, icon, and schema metadata used by ADAMANT apps.

The data is optimized for wallet behavior, display, node/service reliability, and downstream compatibility.

## Structure

- `assets/general/<coin-or-token>/info.json` - shared coin or token metadata
- `assets/general/<coin-or-token>/images/` - icon assets for PWA and iOS apps
- `assets/blockchains/<blockchain>/info.json` - blockchain-level metadata and defaults
- `assets/blockchains/<blockchain>/<token>/info.json` - token overrides for a specific blockchain
- `specification/openapi.json` - OpenAPI schema for the metadata objects

## Override model

Consumers should read metadata in this order:

1. Load shared metadata from `assets/general/<coin-or-token>/info.json`
2. Apply blockchain defaults from `assets/blockchains/<blockchain>/info.json` when the asset belongs to a blockchain family
3. Apply token-specific blockchain overrides from `assets/blockchains/<blockchain>/<token>/info.json`

The JSON assets are the implementation source of truth for current wallet metadata. If this README or `specification/openapi.json` disagrees with assets, fix the documentation or schema drift without changing wallet behavior silently.

## Blockchain metadata

Each blockchain directory includes an `info.json` file that points to the main coin and the coin used for fees:

```jsonc
{
  "blockchain": "Ethereum", // Blockchain readable name
  "type": "ERC20", // How an app should mark token blockchain
  "mainCoin": "ethereum", // A coin containing parameters common to the blockchain
  "fees": "ethereum", // Coin to pay fees in
  "defaultGasLimit": 60000, // Optional. Fallback gas limit for Ethereum-like transfers
  "defaultGasPriceGwei": 40, // Optional. Fallback gas price in Gwei
  "reliabilityGasLimitPercent": 110, // Optional. Gas limit multiplier percent for safer tx acceptance
  "reliabilityGasPricePercent": 110, // Optional. Gas price multiplier percent for safer tx acceptance
  "increasedGasPricePercent": 120, // Optional. Multiplier percent for the "Increase fee" option
}
```

Navigate to `assets/general/${mainCoin}` to get explorer links, address validation, services, nodes, icons, and other shared blockchain parameters.

## Coin and token metadata

Coin and token metadata is stored in `assets/general/${token_name}/info.json`. Blockchain-specific files may override fields for assets issued on a specific chain.

```jsonc
{
  "name": "Example Coin", // Readable coin name
  "nameShort": "Example", // Optional. Readable coin short name
  "website": "https://example.com", // Project website URL
  "description": "Example coin metadata.", // Short description

  "explorer": "https://explorer.example.com", // Optional. Explorer URL
  "explorerTx": "https://explorer.example.com/tx/${ID}", // Optional. URL to get tx info
  "explorerAddress": "https://explorer.example.com/address/${ID}", // Optional. URL to get address info
  "explorerContract": "https://explorer.example.com/contract/${ID}", // Optional. URL to get contract info

  "regexAddress": "^EC([0-9]{8,})$", // Optional. RegExp to validate coin address
  "research": "https://research.example.com/projects/example", // Optional. Research URL
  "symbol": "SYM", // Coin ticker
  "type": "coin", // "coin" or "token"

  "decimals": 8, // Decimal places
  "cryptoTransferDecimals": 8, // Max precision for tx

  "minBalance": 0.00001, // Optional. Minimum acceptable amount for an address
  "minTransferAmount": 0.00000546, // Optional. Minimum acceptable amount for tx

  "fixedFee": 0.5, // Optional. Fixed transfer fee

  // Optional. When the transfer fee is variable, but an app has not yet calculated it
  "defaultFee": 0.00003153,

  "qqPrefix": "exmpl", // Optional. QR code prefix for an address
  "status": "active", // "active" or "disabled". Should the coin be processed

  // Should an app itself create the coin or only use the info for the blockchain
  "createCoin": true,

  "defaultVisibility": true, // Optional. Show a coin by default, or hide it
  "defaultOrdinalLevel": 0, // Optional. Default ordinal number in a wallet list. Coins with the same ordinal number are sorted alphabetically. Coins without an order are shown last, alphabetically

  "consensus": "dPoS", // Optional. Blockchain consensus type
  "blockTimeFixed": 5000, // Optional. Fixed block time in ms
  "blockTimeAvg": 600000, // Optional. Average block time in ms

  "balanceCheckInterval": 30000, // How often to check the wallet balance in ms
  "balanceCheckIntervalNewAccount": 5000, // Optional. How often to check the balance for newly created accounts in ms
  "balanceValidInterval": 300000, // How long a balance is considered valid before requiring refresh in ms

  // Optional. Node links for API
  "nodes": {
    "displayName": "Example nodes", // Name of the node group
    "list": [
      { "url": "https://node.example.com" },
      { "url": "http://0.0.0.0:36666" }, // IP:port URI is allowed
      {
        "url": "https://second-node.example.com",
        "alt_ip": "0.0.0.1:36666", // Alternative connection if the node domain is censored
        "hasIndex": true, // Optional. Whether the node has transaction indexing support
      },
    ],
    // Node health check information
    "healthCheck": {
      "normalUpdateInterval": 210000, // Regular node status update interval in ms
      "crucialUpdateInterval": 30000, // Node status update interval when there are no active nodes, in ms
      "onScreenUpdateInterval": 10000, // Node status update interval on the node screen, in ms
      "threshold": 3, // Permissible height difference between nodes
    },
    "minVersion": "1.0.0", // Optional. Minimal supported node API version
    "nodeTimeCorrection": 500, // Optional. Time correction for ADM message transactions
  },

  // Optional. Services related to a project
  "services": {
    "infoService": {
      "displayName": "Example info service", // Name of the service group
      "description": {
        "software": "example-service", // Service software name
        "github": "https://github.com/example/service", // Optional. Source repository
        "docs": "https://docs.example.com", // Optional. API docs
      },
      "list": [
        { "url": "https://info.example.com" },
        {
          "url": "https://second-service.example.com",
          "alt_ip": "0.0.0.1:80", // Alternative connection if the service domain is censored
        },
      ],
      // Optional. Service health check information.
      // If omitted, consumers may fall back to nodes.healthCheck where supported.
      "healthCheck": {
        "normalUpdateInterval": 210000, // Regular service status update interval in ms
        "crucialUpdateInterval": 30000, // Service status update interval when there are no active services, in ms
        "onScreenUpdateInterval": 10000, // Service status update interval on the node screen, in ms
        "threshold": 3, // Optional. Permissible height difference between indexed services
      },
      "minVersion": "1.0.0", // Optional. Minimal supported service API version
    },
    "service2": {/*...*/},
  },

  // Optional. Additional project links
  "links": [
    {
      "name": "github", // Link label
      "url": "https://github.com/example", // Link URL
    },
    {
      "name": "whitepaper",
      "url": "https://example.com/whitepaper.pdf",
    },
  ],
}
```

### Token overrides

Token overrides in `assets/blockchains/<blockchain>/<token>/info.json` usually contain only fields that differ from shared metadata:

```jsonc
{
  "name": "Tether USD", // Readable token name on this blockchain
  "symbol": "USDT", // Token ticker
  "status": "active", // "active" or "disabled". Should the token be processed
  "contractId": "0xdac17f958d2ee523a2206206994597c13d831ec7", // Blockchain contract address or ID
  "decimals": 6, // Decimal places on this blockchain
  "cryptoTransferDecimals": 6, // Optional. Max precision for tx on this blockchain
  "defaultVisibility": true, // Optional. Show a token by default, or hide it
  "defaultOrdinalLevel": 10, // Optional. Default ordinal number in a wallet list
}
```

Do not duplicate general fields in token override files unless the blockchain-specific value is intentionally different.

## Nodes and services

`nodes` describe blockchain API endpoints. `services` describe project-specific service groups such as info services, indexers, and IPFS nodes.

Keep endpoint lists diverse. Do not replace a list with a single endpoint unless there is an explicit reliability reason. When editing endpoints that may be affected by DNS censorship or availability issues, keep valid `alt_ip` fallbacks where they already exist.

`pnpm run validate:endpoints` checks every node and service list for absolute HTTP(S) URLs, literal-IP `alt_ip` fallbacks, and duplicate URLs. It is also included in the complete `pnpm run validate` command. Live availability still requires an explicit network check because CI validation is intentionally deterministic.

Health checks use millisecond intervals:

- `normalUpdateInterval` - regular update interval.
- `crucialUpdateInterval` - update interval when there are no active nodes or services.
- `onScreenUpdateInterval` - update interval while the node screen is visible.
- `threshold` - allowed height difference between nodes or indexed services.

`minVersion` defines the minimal supported service or node API version. `nodeTimeCorrection` is used for ADM message transaction timestamps.

## Ethereum and ERC20 fees

The total cost of an Ethereum-like transaction is:

```math
Tx fee = gas limit * gas price
```

ADAMANT apps estimate gas limit and gas price with the `web3` library. To improve acceptance reliability, apps multiply those estimates by `reliabilityGasLimitPercent` and `reliabilityGasPricePercent`.

If estimates are unavailable, apps use `defaultGasLimit` and `defaultGasPriceGwei`. When the gas price exceeds `warningGasPriceGwei`, apps may show a warning. The "Increase fee" option uses `increasedGasPricePercent`; Bitcoin metadata may also use this field for higher-priority transfers.

These parameters are set in `assets/general/ethereum/info.json`, `assets/blockchains/ethereum/info.json`, or specific token override files.

## In-chat transfer statuses

Read [AIP-12: Non-ADM crypto transfer messages](https://aips.adamant.im/AIPS/aip-12) for the transfer status model.

Status workflow:

```text
Pending -> Registered -> Confirmed, Cancelled, or Inconsistent
```

Apps use `txFetchInfo` to refresh transaction statuses:

```jsonc
{
  // ...
  "txFetchInfo": {
    // Interval between fetching Tx in ms when its current status is
    "newPendingInterval": 10000, // "Pending" for new transactions
    "oldPendingInterval": 3000, // "Pending" for old transactions
    "registeredInterval": 40000, // "Registered"

    // Attempts to fetch Tx when its current status is "Pending"
    "newPendingAttempts": 20, // for new transactions
    "oldPendingAttempts": 3, // for old transactions
  },

  /**
   * Time in ms when the difference between in-chat transfer and Tx timestamp
   * is considered acceptable. Otherwise, an app should mark Tx as `Inconsistent`.
   */
  "txConsistencyMaxTime": 60000,
}
```

A transaction is considered new or old based on the time passed since the in-chat transfer:

```js
const isNew = (admTransferTimestamp) =>
  Date.now() - admTransferTimestamp <
  txFetchInfo.newPendingAttempts * txFetchInfo.newPendingInterval;
```

If the difference between the in-chat transfer timestamp and the blockchain transaction timestamp is greater than `txConsistencyMaxTime`, apps should mark the transfer as `Inconsistent`.

## Message sending timeouts

Users may request message sending while offline. Apps keep retrying regular messages for a configured timeout. If the message still cannot be sent, it becomes `Failed` and can be retried or cancelled manually.

In-chat coin transfer messages have no timeout; apps retry them until successful. Before sending cryptocurrency in chats, apps check node availability so both the node layer and UI can process the transaction correctly.

```jsonc
{
  // ...
  "timeout": {
    "message": 300000, // Timeout for regular messages in ms
    "attachment": 100000, // Timeout for file transfers in ms
  },
}
```

## Tor and testnet metadata

`tor` and `testnet` follow the same nested shape as the root metadata where applicable:

```jsonc
{
  // Optional. Testnet configuration if a project has a test network.
  // It follows the same structure as the root properties where applicable.
  "testnet": {
    "website": "https://testnet.example.com", // Testnet website URL
    "explorer": "https://testnet-explorer.example.com", // Testnet explorer URL
    "nodes": {
      "displayName": "Example testnet nodes", // Name of the testnet node group
      "list": [{ "url": "https://testnet-node.example.com" }],
      "healthCheck": {
        "normalUpdateInterval": 210000, // Regular node status update interval in ms
        "crucialUpdateInterval": 30000, // Node status update interval when there are no active nodes, in ms
        "onScreenUpdateInterval": 10000, // Node status update interval on the node screen, in ms
        "threshold": 3, // Permissible height difference between nodes
      },
    },
  },

  // Optional. Tor configuration if a project uses Tor.
  // It follows the same structure as the root properties.
  "tor": {
    "website": "http://abc.onion", // Tor website URL
    "explorer": "http://xyz.onion", // Tor explorer URL
    "explorerTx": "http://xyz.onion/tx/${ID}", // Tor URL to get tx info
    "explorerAddress": "http://xyz.onion/address/${ID}", // Tor URL to get address info
    "nodes": {}, // Tor node links for API
    "services": {}, // Tor services related to a project
    "links": [], // Additional Tor project links
  },
}
```

## Icons

Coin icons are stored in `assets/general/${token_name}/images`.

Required files:

- `icon.svg` - vector icon
- `icon.vue` - Vue icon template for PWA
- `${token_name}_wallet.png` - iOS wallet icon at 1x, 55 px
- `${token_name}_wallet@2x.png` - iOS wallet icon at 2x
- `${token_name}_wallet@3x.png` - iOS wallet icon at 3x

Optional files:

- `${token_name}_wallet_dark.png`, `${token_name}_wallet_dark@2x.png`, `${token_name}_wallet_dark@3x.png` - dark wallet icons
- `${token_name}_notification.png`, `${token_name}_notification@2x.png`, `${token_name}_notification@3x.png` - iOS push notification icons
- `${token_name}_wallet_row.png`, `${token_name}_wallet_row@2x.png`, `${token_name}_wallet_row@3x.png` - iOS private key screen row icons at 1x, 2x, and 3x

If optional icons are absent, apps use the regular `_wallet` icons.

## Development & Contribution

See [CONTRIBUTING.md](./.github/CONTRIBUTING.md).

## Links

- [ADAMANT website](https://adamant.im)
- [ADAMANT AIPs](https://aips.adamant.im)
- [ADAMANT PWA](https://github.com/Adamant-im/adamant-im)
- [ADAMANT iOS](https://github.com/Adamant-im/adamant-iOS)
- [ADAMANT API JS client](https://github.com/Adamant-im/adamant-api-jsclient)
- [ADAMANT Schema](https://github.com/Adamant-im/adamant-schema)
- [ADAMANT Node](https://github.com/Adamant-im/adamant)
- [ADAMANT Console](https://github.com/Adamant-im/adamant-console)
