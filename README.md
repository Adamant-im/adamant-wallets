# Crypto wallets for ADAMANT apps

Coin/token info and specification for usage in ADAMANT apps.

## Structure

Root directory includes:

- `\general\` — Includes directories for each coin/token, in which `info.json` stores their general descriptions and specifications.
- `\blockchains\` — Contains specific to blockchains information, which can override general specs. Tokens inside are grouped by blockchain as a separate folder.

## Blockchain info

Each blockchain in `\blockchains\` includes `info.json`, which links to main coin in `\general\`:

```jsonc
{
  "blockchain": "Ethereum", // Blockchain readable name
  "type": "ERC20", // How an app should mark token blockchain
  "mainCoin": "ethereum", // A coin containing parameters common to the blockchain
  "fees": "ethereum" // Coin to pay fees in
}
```

Navigate to `\general\${mainCoin}` to get explorer links, address regex and other shared for blockchain parameters.

## Coin/token info

Coin/token info stored in `\general\${token_name}` folders. Specific blockchain info in `\blockchains\${blockchain_name}` overrides it. For example:

```jsonc
{
  "name": "Example Coin", // Readable coin name
  "nameShort": "Example", // Optional. Readable coin short name
  "website": "https://example.com", // Project website URL
  "description": "Non existing coin", // Short description

  "explorer": "https://explorer.example.com", // Optional. Explorer URL
  "explorerTx": "https://explorer.example.com/tx/${ID}", // Optional. URL to get tx info
  "explorerAddress": "https://explorer.example.com/address/${ID}", // Optional. URL to get address info
  "explorerContract": "https://explorer.example.com/contract/${ID}", // Optional. URL to get contract info

  "regexAddress": "^EC([0-9]{8,})$", // Optional. RegEx to validate coin address
  "research": "https://research.binance.com/en/projects/${project}", // Optional. Research URL
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

  "defaultVisibility": true, // Optional. To show a coin by default, or hide it
  "defaultOrdinalLevel": 0, // Optional. Default ordinal number in a wallet list. Coins with the same ordinal number are sorted alphabetically. Coins without an order are shown last, alphabetically

  "consensus": "dPoS", // Optional. Blockchain consensus type
  "blockTimeFixed": 5000, // Optional. Fixed block time in ms
  "blockTimeAvg": 600000, // Optional. Average block time in ms

  // Optional. Node links for API
  "nodes": {
    "displayName": "some-node", // Name of the group of the nodes
    "list": [
      { "url": "https://node.example.com" },
      { "url": "http://0.0.0.0:36666" }, // It's possible to use IP:port URI
      {
        "url": "https://second-node.example.com",
        "alt_ip": "0.0.0.1:36666" // Alternative way to connect if the domain of a node is censored
      }
    ],
    // Node health check information 
    "healthCheck": {
      "normalUpdateInterval": 210000, // Regular node status update interval in ms
      "crucialUpdateInterval": 30000, // Node status update interval when there are no active nodes, in ms
      "onScreenUpdateInterval": 10000, // On the node screen, the status update interval in ms
      "threshold": 3  // Permissible height difference between nodes
    },
    "minVersion": "1.0.0", // Optional. Minimal supported service API version
    "nodeTimeCorrection": 500 // Optional. A time correction for the message transactions on ADM
  },

  // Optional. Services related to a project
  "services": {
    "service1": {
      "displayName": "some-service", // Name of the group of the services
      "description": {
        "software": "example-service",
        "github": "https://github.com/--example",
        "docs": "https://docs.example.com" // API docs
      },
      "list": [
        {
          "url": "https://info.example.com",
        },
        {
          "url": "https://second-service.example.com",
          "alt_ip": "0.0.0.1:80" // Alternative way to connect if the domain of a service is censored
        }
      ],
      // Optional: Service health check information (If not filled here, information is retrieved from nodes.healthCheck)
      "healthCheck": {
        "normalUpdateInterval": 210000, // Regular service status update interval in ms
        "crucialUpdateInterval": 30000, // Service status update interval when there are no active services, in ms
        "onScreenUpdateInterval": 10000 // On the node screen, the status update interval in ms
      },
      "minVersion": "1.0.0", // Optional. Minimal supported service API version 
    },
    "service2": {
      /*...*/
    }
  },

  // Optional. Additional project links
  "links": [
    {
      "name": "github",
      "url": "https://github.com/--example"
    },
    {
      "name": "whitepaper",
      "url": "https://example.com/whitepaper.pdf"
    }
  ],

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

### Ethereum & ERC20 tx fee calculation

The total cost of a transaction is the product of the gas limit and gas price:

```math
Tx \, fee = gas \, limit \times gas \, price
```

ADAMANT apps estimate gas limit and gas price using [web3](https://github.com/web3/web3.js) library. To ensure the Ethereum blockchain will accept the tx, apps multiply these estimates by `reliabilityGasLimitPercent` and `reliabilityGasPricePercent`. Additionally, an app may offer the "Increase fee" option to use the `increasedGasPricePercent` koef.

If it’s not possible to get estimates, apps will use `defaultGasLimit` and `defaultGasPriceGwei`. When the gas price exceeds `warningGasPriceGwei`, apps show a note/warning.

These parameters are set inside `general\ethereum\info.json` and may be overridden by `blockchains\ethereum\info.json` and specific tokens.

### Info for updating in-chat coin transfer tx statuses

> Read [AIP-12: Non-ADM crypto transfer messages](https://aips.adamant.im/AIPS/aip-12) to learn more about Tx statuses.

Statuses workflow: `Pending` (new or old tx) ⟶ `Registered` ⟶ `Confirmed`, `Cancelled` or `Inconsistent`.

To help apps with updating statuses, additional fields are introduced:

```jsonc
{
  // ...
  "txFetchInfo": {
    // Interval between fetching Tx in ms when its current status is
    "newPendingInterval": 10000, // "Pending" for new transactions
    "oldPendingInterval": 3000, // "Pending" for old transactions
    "registeredInterval": 40000, // "Registered"

    // Attempts to fetch Tx when its current status is `Pending`
    "newPendingAttempts": 20, // for new transactions
    "oldPendingAttempts": 3 // for old transactions
  },

  /**
   * Time in ms when difference between in-chat transfer and Tx timestamp considered
   * as acceptable. Otherwise, an app should mark Tx as `Inconsistent`.
   */
  "txConsistencyMaxTime": 60000
}
```

Transaction considered as new or old depending on how much time passed from in-chat transfer.

```js
const isNew = (admTransferTimestamp) =>
  Date.now() - admTransferTimestamp <
  newPendingTxFetchAttempts * newPendingTxFetchInterval;
```

### Message sending

Users can request to send messages even when they are offline. An app will attempt to send a message for a specific timeout period, allowing time for the Internet connection to restore. If the message still cannot be sent, the status will change from “Pending” to “Failed”. Users can then manually retry sending the message or choose to cancel it.

For in-chat coin transfers, there is no timeout. An app will continuously retry sending these messages until successful. However, before sending cryptocurrency in chats, the app checks the availability of all nodes, ensuring both the nodes and the UI process the transaction correctly.

To assist apps in setting message sending parameters, additional fields are introduced:

```jsonc
{
  // ...
  "timeout": {
    "message": 300000, // Timeout for regular messages (in milliseconds)
    "attachment": 100000,   // Timeout for file transfers (in milliseconds)
  },
}
```

## Icons

Coin icons/images files are stored `\general\${token_name}\images` folders.

Required:

- `icon.svg` — Vector image file
- `icon.vue` — Vector image vue template for PWA
- `${token_name}_wallet.png` — @x1 (55px) resolution for iOS app
- `${token_name}_wallet@2x.png` — same, @x2 resolution
- `${token_name}_wallet@3x.png` — same, @x3 resolution

Optional:

- `${token_name}_wallet_dark.png` — @x1 (55px) resolution for iOS app, dark icon
- `${token_name}_wallet_dark@2x.png` — same, @x2 resolution
- `${token_name}_wallet_dark@3x.png` — same, @x3 resolution
- `${token_name}_notification.png` — @x1 (55px) resolution for iOS push notifications
- `${token_name}_notification@2x.png` — same, @x2 resolution
- `${token_name}_notification@3x.png` — same, @x3 resolution
- `${token_name}_wallet_row.png` — @x1 (21px) resolution for iOS app for private key screen
- `${token_name}_wallet_row@2x.png` — same, @x2 resolution
- `${token_name}_wallet_row@3x.png` — same, @x3 resolution

If there will be no optional icons, apps will take regular `_wallet` icons.

## Contribution

Please have a look at the [CONTRIBUTING.md](./.github/CONTRIBUTING.md).
