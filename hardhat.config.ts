import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
require('dotenv').config();
const { PRIVATE_KEY } = process.env;

const config: HardhatUserConfig = {
  solidity: "0.8.17",
  networks: {
    xinfin: {
      url: "https://erpc.xinfin.network",
      accounts: [PRIVATE_KEY],
      allowUnlimitedContractSize: true
    },

    apothem: {
      url: "https://erpc.apothem.network",
      accounts: [PRIVATE_KEY],
      allowUnlimitedContractSize: true
    }
  },
  // etherscan: {
  //   apiKey: process.env.API_KEY
  // }
};

export default config;
