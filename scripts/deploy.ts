import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { ethers, hardhatArguments } from 'hardhat';

function delay(ms: number) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

async function deployContractsFixture() {
  const network = hardhatArguments.network ? hardhatArguments.network : 'dev';
  const blockNumBefore = await ethers.provider.getBlockNumber();
  const blockBefore = await ethers.provider.getBlock(blockNumBefore);
  const timestampBefore = blockBefore.timestamp;

  const [owner] = await ethers.getSigners();
  console.log('deploy from address: ', owner.address);

  const Admin = await ethers.getContractFactory("ProxyAdmin");
  const admin = await Admin.deploy();
  console.log('Admin address: ', admin.address);

  const PublisherRegistry = await ethers.getContractFactory("PublisherRegistry");
  const publisherRegistry = await PublisherRegistry.deploy();
  console.log('PublisherRegistry address: ', publisherRegistry.address);

  const Oracle = await ethers.getContractFactory("Oracle");
  const oracle = await Oracle.deploy();
  console.log('Oracle address: ', oracle.address);

  const fragment = Oracle.interface.getFunction("initialize");
  const data = Oracle.interface.encodeFunctionData(fragment, [
    publisherRegistry.address,
    [{
      id: ethers.utils.formatBytes32String('USD'),
      decimals: 8,
      isAbstractCurrency: true,
      ethereumAddress: ethers.constants.AddressZero,
    },
    {
      id: ethers.utils.formatBytes32String('ETH'),
      decimals: 18,
      isAbstractCurrency: true,
      ethereumAddress: ethers.constants.AddressZero,
    }],
    [{
      id: ethers.utils.formatBytes32String('ETH/USD'),
      quoteCurrencyId: ethers.utils.formatBytes32String('ETH'),
      baseCurrencyId: ethers.utils.formatBytes32String('USD'),
    }]
  ]);

  await delay(10000);
  const TransparentUpgradeableProxy = await ethers.getContractFactory("TransparentUpgradeableProxy");
  const proxy = await TransparentUpgradeableProxy.deploy(oracle.address, admin.address, data);
  const oracleProxy = await Oracle.attach(proxy.address);
  console.log("Proxy address: ", oracleProxy.address);



  // console.log("addPublisher");
  // await publisherRegistry.addPublisher(
  //   ethers.utils.formatBytes32String('DATUM'),
  //   owner.address,
  // );

  // await delay(10000);
  // console.log("addSourcesForPublisher");
  // await publisherRegistry.addSourcesForPublisher(
  //   ethers.utils.formatBytes32String('DATUM'),
  //   [
  //     ethers.utils.formatBytes32String('SOURCE1'),
  //     ethers.utils.formatBytes32String('SOURCE2'),
  //     ethers.utils.formatBytes32String('SOURCE3'),
  //     ethers.utils.formatBytes32String('SOURCE4'),
  //   ]
  // );

  // console.log("publishSpotEntry");
  // await oracleProxy.connect(owner).publishSpotEntry(
  //   {
  //     base: {
  //       timestamp: timestampBefore + 60,
  //       source: ethers.utils.formatBytes32String('SOURCE1'),
  //       publisher: ethers.utils.formatBytes32String('DATUM'),
  //     },
  //     pairId: ethers.utils.formatBytes32String('ETH/USD'),
  //     price: 10000000000,
  //     volume: 100000,
  //   }
  // );
  // const response = await oracleProxy.getSpot(
  //   ethers.utils.formatBytes32String('ETH/USD'),
  //   ethers.BigNumber.from("0"),
  //   [
  //     ethers.utils.formatBytes32String('SOURCE1'),
  //     ethers.utils.formatBytes32String('SOURCE2'),
  //   ]
  // );

  // console.log("publishSpotEntry");
  // await oracleProxy.connect(owner).publishSpotEntry(
  //   {
  //     base: {
  //       timestamp: timestampBefore + 60,
  //       source: ethers.utils.formatBytes32String('SOURCE2'),
  //       publisher: ethers.utils.formatBytes32String('DATUM'),
  //     },
  //     pairId: ethers.utils.formatBytes32String('ETH/USD'),
  //     price: 11000000000,
  //     volume: 100000,
  //   }
  // );

  // console.log("getSpot");
  // const response2 = await oracleProxy.getSpot(
  //   ethers.utils.formatBytes32String('ETH/USD'),
  //   ethers.BigNumber.from("0"),
  //   [
  //     ethers.utils.formatBytes32String('SOURCE1'),
  //     ethers.utils.formatBytes32String('SOURCE2'),
  //   ]
  // );


  // console.log(response);
  // console.log(response2);



}

async function main() {

  await deployContractsFixture();

}


main().then(() => process.exit(0))
  .catch(err => {
    console.error(err);
    process.exit(1);
  });