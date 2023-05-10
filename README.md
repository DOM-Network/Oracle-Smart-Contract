# Decentralized Oracle on XDC Network
![alt text](https://github.com/DOM-Network/EVM-Oracle/blob/main/PriceFeed.PNG)

There will be 3 components involved in providing data:

- Publishers:  Collect data off-chain and put into Oracle smart contract.
- Publisher Registry Smart Contract: Manage publishers and data sources.
- Oracle Smart Contract: receive data off-chain from Publishers and perform data aggregation.

Publisher Registry Smart Contract adds and updates publishers and data sources -> Eligible publishers collect data from off-chain sources, injecting data into Oracle Smart Contracts ->Oracle Smart Contract performs data aggregation.

- Data Source:
  + Bitstamp
  + Coinbase
  + Ascendex
  + Okx
  + Gemini
- Pairs:
  + BTC/USD
  + WBTC/BTC
  + WBTC/USD
  + BTC/EUR
  + ETH/USD
  + SOL/USD
  + AVAX/USD
  + DOGE/USD
  + SHIB/USD
  + FIL/USD
  + DAI/USD
  + USDT/USD
  + USDC/USD
  + TUSD/USD
  + BNB/USD
  + ADA/USD
  + XRP/USD
  + MATIC/USD
  + AAVE/USD
