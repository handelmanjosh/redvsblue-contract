import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import dotenv from "dotenv";
dotenv.config();
const config: HardhatUserConfig = {
  solidity: "0.8.24",
  networks: {
    // for mainnet
    // 'base-mainnet': {
    //   url: 'https://mainnet.base.org',
    //   accounts: [process.env.PRIVATE_KEY as string],
    //   gasPrice: 1000000000,
    //   loggingEnabled: true,
    // },
    // for testnet
    'base-sepolia': {
      url: 'https://sepolia.base.org',
      accounts: [process.env.PRIVATE_KEY as string],
      gasPrice: 1000000000,
      loggingEnabled: true,

    },
  },
  etherscan: {
    apiKey: {
     "base-sepolia": "PLACEHOLDER_STRING"
    },
    customChains: [
      {
        network: "base-sepolia",
        chainId: 84532,
        urls: {
         apiURL: "https://api-sepolia.basescan.org/api",
         browserURL: "https://sepolia.basescan.org"
        }
      }
    ]
  },
};

export default config;
