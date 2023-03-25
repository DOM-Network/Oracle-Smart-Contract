import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { ethers, hardhatArguments } from 'hardhat';
import { currencies, pairs } from "./data";

function delay(ms: number) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

async function deployContractsFixture() {
  const network = hardhatArguments.network ? hardhatArguments.network : 'dev';
  const blockNumBefore = await ethers.provider.getBlockNumber();
  const blockBefore = await ethers.provider.getBlock(blockNumBefore);
  const timestampBefore = blockBefore.timestamp;
  console.log("Network: ", network);
  console.log("Timestamp: ", blockBefore.timestamp)

  const [owner] = await ethers.getSigners();
  console.log('deploy from address: ', owner.address);
  const balance = await owner.getBalance();
  // console.log(balance);

  const Admin = await ethers.getContractFactory("ProxyAdmin");
  const admin = await Admin.deploy();
  console.log('Admin address: ', admin.address);
  await delay(5000);

  const PublisherRegistry = await ethers.getContractFactory("PublisherRegistry");
  const publisherRegistry = await PublisherRegistry.deploy();
  console.log('PublisherRegistry address: ', publisherRegistry.address);
  await delay(5000);

  const Oracle = await ethers.getContractFactory("Oracle");
  const oracle = await Oracle.deploy();
  console.log('Oracle address: ', oracle.address);
  await delay(5000);

  const fragment = Oracle.interface.getFunction("initialize");
  const data = Oracle.interface.encodeFunctionData(fragment, [
    publisherRegistry.address,
    currencies,
    pairs
  ]);

  await delay(5000);
  const TransparentUpgradeableProxy = await ethers.getContractFactory("TransparentUpgradeableProxy");
  const proxy = await TransparentUpgradeableProxy.deploy(oracle.address, admin.address, data);
  const oracleProxy = await Oracle.attach(proxy.address);
  console.log("Proxy address: ", oracleProxy.address);



  console.log("addPublisher");
  await publisherRegistry.addPublisher(
    ethers.utils.formatBytes32String('DOM'),
    owner.address,
  );

  await delay(10000);
  console.log("addSourcesForPublisher");
  await publisherRegistry.addSourcesForPublisher(
    ethers.utils.formatBytes32String('DOM'),
    [
      ethers.utils.formatBytes32String('BITSTAMP'),
      ethers.utils.formatBytes32String('COINBASE'),
      ethers.utils.formatBytes32String('ASCENDEX'),
      ethers.utils.formatBytes32String('OKX'),
      ethers.utils.formatBytes32String('GEMINI'),
    ]
  );
}

async function main() {
  await deployContractsFixture();
}


main().then(() => process.exit(0))
  .catch(err => {
    console.error(err);
    process.exit(1);
  });