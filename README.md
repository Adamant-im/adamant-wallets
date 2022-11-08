# Crypto wallets in ADAMANT apps

Coin/token info and specification for usage in ADAMANT apps.

## Structure

Root directory includes:

- `\general` General coin/token descriptions and specifications. Includes directories for each coin/token, in which `info.json` stores their specifications.
- `\blockchains` Specific to blockchain information, which can override general specs. Tokens inside are grouped by blockchain as a separate folder.

## Blockchain info

Each blockchain in `\blockchains` includes `info.json`, which links to main coin in `\general`:

``` jsonc
{
  "blockchain": "Ethereum", // Blockchain readable name
  "type": "ERC20", // How an app should mark token blockchain
  "mainCoin": "ethereum", // Navigate to `\general\ethereum` to get explorer links, address regex and other shared for blockchain parameters
  "fees": "ethereum" // Coin to pay fees in
}
```

## Coin/token info

Coin/token info stored in `\general\${token_name}` folders. Specific blockchain info in `\blockchains\${blockchain_name}` overrides it.

- `name` Readable coin name
- `website` Project website
- `description` Short description
- `explorer` Explorer url
- `explorerTx` URL to receive tx info
- `explorerAddress` URL to receive address info
- `regexAddress` Regex to validate coin address
- `symbol` Coin ticker
- `type` Coin or token mainly
- `decimals` Decimal places
- `cryptoTransferDecimals` Max precision for transactions
- `minBalance` If there are blockchain limitations on minimum amount for an address
- `minTransferAmount` If there are blockchain limitations on minimum amount to transfer
- `fixedFee` If to use fixed tx transfer fee
- `defaultFee` If tx fee is variable, but an app had not calculated it yet
- `qqPrefix` QR code prefix for address
- `status` If an app should process a coin
- `createCoin` If an app should create a coin itself. `false` means use info only for blockchains.
- `consensus` Blockchain consensus type
- `blockTimeFixed` Fixed block time in ms
- `blockTimeAvg` Average block time in ms
- `nodes` Node links for API
- `links` Additional project links

### Info for updating in-chat coin transfer tx statuses

Read [AIP-12: Non-ADM crypto transfer messages](https://aips.adamant.im/AIPS/aip-12) for info about Tx statuses.

Statuses workflow: `Pending` (new or old tx) ⟶ `Registered` ⟶ `Confirmed`, `Cancelled` or `Inconsistent`.

To help apps with updating statuses, additional fields are introduced:

- `newPendingTxFetchInterval` Time in ms between fetching Tx when its current status is `Pending` for new transactions
- `oldPendingTxFetchInterval` Time in ms between fetching Tx when its current status is `Pending` for old transactions
- `registeredTxFetchInterval` Time in ms between fetching Tx when its current status is `Registered`
- `newPendingTxFetchAttempts` Attempts to fetch Tx when its current status is `Pending` for new transactions
- `oldPendingTxFetchAttempts` Attempts to fetch Tx when its current status is `Pending` for old transactions
- `txConsistencyMaxTime` Time in ms when difference between in-chat transfer and Tx timestamp considered as acceptable. Otherwise, an app should mark Tx as `Inconsistent`.

Transaction considered as new or old depending on how much time passed from in-chat transfer.

``` js
export const isNew = (admTransferTimestamp) => (Date.now() - admTransferTimestamp) < newPendingTxFetchAttempts * newPendingTxFetchInterval
```

## Icons

Coin icons/images files are stored `\general\${token_name}` folders:

- `icon.svg` Vector image for PWA
- `icon_muted_55.png` @x1 resolution for iOS app, muted
- `icon_muted_110.png` @x2 resolution for iOS app, muted
- `icon_muted_165.png` @x3 resolution for iOS app, muted
- `icon_original_165.png` @x3 resolution for iOS app, original color

Muted means image with reduced saturation, about -30%.
