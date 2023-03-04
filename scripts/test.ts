import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import { ethers } from "hardhat";
import { Oracle } from "../typechain-types";


console.log(ethers.utils.formatBytes32String('SOURCE1'));