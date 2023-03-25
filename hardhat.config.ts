import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from "dotenv";
dotenv.config({ path: __dirname + "/.env" });



const config: HardhatUserConfig = {
  solidity: "0.8.17",
  networks: {
    filecoin_hyperspace: {
      url: "https://api.hyperspace.node.glif.io/rpc/v1",
      accounts: ["1dd3a5652ee5590dca9f6afef8340fab052a144c710505bd2341bb9387b3a23f"],
      allowUnlimitedContractSize: true
    },
    bsctest: {
      url: "https://data-seed-prebsc-2-s2.binance.org:8545",
      accounts: ["1dd3a5652ee5590dca9f6afef8340fab052a144c710505bd2341bb9387b3a23f"],
      allowUnlimitedContractSize: true
    },
    XRPLtest: {
      url: "https://rpc-evm-sidechain.peersyst.tech/",
      accounts: ["1dd3a5652ee5590dca9f6afef8340fab052a144c710505bd2341bb9387b3a23f"],
      allowUnlimitedContractSize: true
    }
  },
  // etherscan: {
  //   apiKey: process.env.API_KEY
  // }
};

export default config;
