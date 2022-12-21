# Crypto wallets for ADAMANT apps

Coin/token info and specification for usage in ADAMANT apps.

## Structure

Root directory includes:

- `\general\` — Includes directories for each coin/token, in which `info.json` stores their general descriptions and specifications.
- `\blockchains\` — Contains specific to blockchains information, which can override general specs. Tokens inside are grouped by blockchain as a separate folder.

## Blockchain info

Each blockchain in `\blockchains\` includes `info.json`, which links to main coin in `\general\`:

``` jsonc
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

  "regexAddress": "/^EC([0-9]{8,})$/i", // Optional. RegEx to validate coin address
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

  "consensus": "dPoS", // Optional. Blockchain consensus type
  "blockTimeFixed": 5000, // Optional. Fixed block time in ms
  "blockTimeAvg": 600000, // Optional. Average block time in ms

  // Optional. Node links for API
  "nodes": [
    { "url": "https://node.example.com" },
    { "url": "http://0.0.0.0:36666" }
  ],
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
  ]
}
```

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
    "oldPendingInterval": 3000,  // "Pending" for old transactions
    "registeredInterval": 40000, // "Registered"

    // Attempts to fetch Tx when its current status is `Pending`
    "newPendingAttempts": 20, // for new transactions
    "oldPendingAttempts": 3,  // for old transactions
  },

  /**
   * Time in ms when difference between in-chat transfer and Tx timestamp considered
   * as acceptable. Otherwise, an app should mark Tx as `Inconsistent`.
   */
  "txConsistencyMaxTime": 60000,
}
```

Transaction considered as new or old depending on how much time passed from in-chat transfer.

``` js
const isNew = (admTransferTimestamp) => (
  (Date.now() - admTransferTimestamp) < (newPendingTxFetchAttempts * newPendingTxFetchInterval)
)
```

## Icons

Coin icons/images files are stored `\general\${token_name}\Images` folders:

- `icon.svg` — Vector image file
- `icon.vue` — Vector image vue template for PWA
- `${token_name}_wallet.png` — @x1 resolution for iOS app
- `${token_name}_wallet@2x.png` — @x2 resolution for iOS app
- `${token_name}_wallet@3x.png` — @x3 resolution for iOS app
- `${token_name}_wallet_dark.png` — @x1 resolution for iOS app, dark icon. Optional!
- `${token_name}_wallet_dark@2x.png` — @x2 resolution for iOS app, dark icon. Optional!
- `${token_name}_wallet_dark@3x.png` — @x3 resolution for iOS app, dark icon. Optional!
- `${token_name}_notification.png` — @x1 resolution for iOS notification
- `${token_name}_notification@2x.png` — @x2 resolution for iOS notification
- `${token_name}_notification@3x.png` — @x3 resolution for iOS notification
