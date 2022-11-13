import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomiclabs/hardhat-etherscan"
import 'dotenv/config';
// verify
import { setGlobalDispatcher, ProxyAgent } from "undici"
const proxyAgent = new ProxyAgent('http://127.0.0.1:1080')
setGlobalDispatcher(proxyAgent)

// alchemy api key
const ALCHEMY_API_KEY: string = process.env.ALCHEMY_API_KEY as string;
// georli Metamask account PRIVATE key
const GOERLI_PRIVATE_KEY: string = process.env.GOERLI_PRIVATE_KEY as string;
// echerscan api key
const ETHERSCAN_API_KEY: string = process.env.ETHERSCAN_API_KEY as string;

const config: HardhatUserConfig = {
  solidity: "0.8.17",
  networks: {
    goerli: {
      url: `https://eth-goerli.alchemyapi.io/v2/${ALCHEMY_API_KEY}`,
      accounts: [GOERLI_PRIVATE_KEY],
      chainId: 5,
    },
  },
  etherscan: {
    apiKey: ETHERSCAN_API_KEY,
  },
};




export default config;
