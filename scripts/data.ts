import { ethers, hardhatArguments } from 'hardhat';

let currencies = [
    {
        id: ethers.utils.formatBytes32String('USD'),
        decimals: 8,
        isAbstractCurrency: true,
        ethereumAddress: ethers.constants.AddressZero,
    },
    {
        id: ethers.utils.formatBytes32String('EUR'),
        decimals: 8,
        isAbstractCurrency: true,
        ethereumAddress: ethers.constants.AddressZero,
    },
    {
        id: ethers.utils.formatBytes32String('BTC'),
        decimals: 18,
        isAbstractCurrency: true,
        ethereumAddress: ethers.constants.AddressZero,
    },
    {
        id: ethers.utils.formatBytes32String('WBTC'),
        decimals: 18,
        isAbstractCurrency: true,
        ethereumAddress: ethers.constants.AddressZero,
    },
    {
        id: ethers.utils.formatBytes32String('ETH'),
        decimals: 18,
        isAbstractCurrency: true,
        ethereumAddress: ethers.constants.AddressZero,
    },
    {
        id: ethers.utils.formatBytes32String('SOL'),
        decimals: 18,
        isAbstractCurrency: true,
        ethereumAddress: ethers.constants.AddressZero,
    },
    {
        id: ethers.utils.formatBytes32String('AVAX'),
        decimals: 18,
        isAbstractCurrency: true,
        ethereumAddress: ethers.constants.AddressZero,
    },
    {
        id: ethers.utils.formatBytes32String('DOGE'),
        decimals: 18,
        isAbstractCurrency: true,
        ethereumAddress: ethers.constants.AddressZero,
    },
    {
        id: ethers.utils.formatBytes32String('SHIB'),
        decimals: 18,
        isAbstractCurrency: true,
        ethereumAddress: ethers.constants.AddressZero,
    },
    {
        id: ethers.utils.formatBytes32String('FIL'),
        decimals: 18,
        isAbstractCurrency: true,
        ethereumAddress: ethers.constants.AddressZero,
    },
    {
        id: ethers.utils.formatBytes32String('DAI'),
        decimals: 18,
        isAbstractCurrency: true,
        ethereumAddress: ethers.constants.AddressZero,
    },
    {
        id: ethers.utils.formatBytes32String('USDT'),
        decimals: 18,
        isAbstractCurrency: true,
        ethereumAddress: ethers.constants.AddressZero,
    },
    {
        id: ethers.utils.formatBytes32String('USDC'),
        decimals: 18,
        isAbstractCurrency: true,
        ethereumAddress: ethers.constants.AddressZero,
    },
    {
        id: ethers.utils.formatBytes32String('TUSD'),
        decimals: 18,
        isAbstractCurrency: true,
        ethereumAddress: ethers.constants.AddressZero,
    },
    {
        id: ethers.utils.formatBytes32String('BNB'),
        decimals: 18,
        isAbstractCurrency: true,
        ethereumAddress: ethers.constants.AddressZero,
    },
    {
        id: ethers.utils.formatBytes32String('ADA'),
        decimals: 18,
        isAbstractCurrency: true,
        ethereumAddress: ethers.constants.AddressZero,
    },
    {
        id: ethers.utils.formatBytes32String('MATIC'),
        decimals: 18,
        isAbstractCurrency: true,
        ethereumAddress: ethers.constants.AddressZero,
    },
    {
        id: ethers.utils.formatBytes32String('AAVE'),
        decimals: 18,
        isAbstractCurrency: true,
        ethereumAddress: ethers.constants.AddressZero,
    },
]

let pairs = [
    {
        id: ethers.utils.formatBytes32String('BTC/USD'),
        quoteCurrencyId: ethers.utils.formatBytes32String('BTC'),
        baseCurrencyId: ethers.utils.formatBytes32String('USD'),
    },
    {
        id: ethers.utils.formatBytes32String('WBTC/BTC'),
        quoteCurrencyId: ethers.utils.formatBytes32String('WBTC'),
        baseCurrencyId: ethers.utils.formatBytes32String('BTC'),
    },
    {
        id: ethers.utils.formatBytes32String('WBTC/USD'),
        quoteCurrencyId: ethers.utils.formatBytes32String('WBTC'),
        baseCurrencyId: ethers.utils.formatBytes32String('USD'),
    },
    {
        id: ethers.utils.formatBytes32String('BTC/EUR'),
        quoteCurrencyId: ethers.utils.formatBytes32String('BTC'),
        baseCurrencyId: ethers.utils.formatBytes32String('EUR'),
    },
    {
        id: ethers.utils.formatBytes32String('ETH/USD'),
        quoteCurrencyId: ethers.utils.formatBytes32String('ETH'),
        baseCurrencyId: ethers.utils.formatBytes32String('USD'),
    },
    {
        id: ethers.utils.formatBytes32String('SOL/USD'),
        quoteCurrencyId: ethers.utils.formatBytes32String('SOL'),
        baseCurrencyId: ethers.utils.formatBytes32String('USD'),
    },
    {
        id: ethers.utils.formatBytes32String('AVAX/USD'),
        quoteCurrencyId: ethers.utils.formatBytes32String('ETH'),
        baseCurrencyId: ethers.utils.formatBytes32String('USD'),
    },
    {
        id: ethers.utils.formatBytes32String('DOGE/USD'),
        quoteCurrencyId: ethers.utils.formatBytes32String('ETH'),
        baseCurrencyId: ethers.utils.formatBytes32String('USD'),
    },
    {
        id: ethers.utils.formatBytes32String('SHIB/USD'),
        quoteCurrencyId: ethers.utils.formatBytes32String('ETH'),
        baseCurrencyId: ethers.utils.formatBytes32String('USD'),
    },
    {
        id: ethers.utils.formatBytes32String('FIL/USD'),
        quoteCurrencyId: ethers.utils.formatBytes32String('ETH'),
        baseCurrencyId: ethers.utils.formatBytes32String('USD'),
    },
    {
        id: ethers.utils.formatBytes32String('DAI/USD'),
        quoteCurrencyId: ethers.utils.formatBytes32String('ETH'),
        baseCurrencyId: ethers.utils.formatBytes32String('USD'),
    },
    {
        id: ethers.utils.formatBytes32String('USDT/USD'),
        quoteCurrencyId: ethers.utils.formatBytes32String('ETH'),
        baseCurrencyId: ethers.utils.formatBytes32String('USD'),
    },
    {
        id: ethers.utils.formatBytes32String('USDC/USD'),
        quoteCurrencyId: ethers.utils.formatBytes32String('ETH'),
        baseCurrencyId: ethers.utils.formatBytes32String('USD'),
    },
    {
        id: ethers.utils.formatBytes32String('TUSD/USD'),
        quoteCurrencyId: ethers.utils.formatBytes32String('ETH'),
        baseCurrencyId: ethers.utils.formatBytes32String('USD'),
    },
    {
        id: ethers.utils.formatBytes32String('BNB/USD'),
        quoteCurrencyId: ethers.utils.formatBytes32String('ETH'),
        baseCurrencyId: ethers.utils.formatBytes32String('USD'),
    },
    {
        id: ethers.utils.formatBytes32String('ADA/USD'),
        quoteCurrencyId: ethers.utils.formatBytes32String('ETH'),
        baseCurrencyId: ethers.utils.formatBytes32String('USD'),
    },
    {
        id: ethers.utils.formatBytes32String('XRP/USD'),
        quoteCurrencyId: ethers.utils.formatBytes32String('ETH'),
        baseCurrencyId: ethers.utils.formatBytes32String('USD'),
    },
    {
        id: ethers.utils.formatBytes32String('MATIC/USD'),
        quoteCurrencyId: ethers.utils.formatBytes32String('ETH'),
        baseCurrencyId: ethers.utils.formatBytes32String('USD'),
    },
    {
        id: ethers.utils.formatBytes32String('AAVE/USD'),
        quoteCurrencyId: ethers.utils.formatBytes32String('ETH'),
        baseCurrencyId: ethers.utils.formatBytes32String('USD'),
    },

]

export { currencies, pairs };