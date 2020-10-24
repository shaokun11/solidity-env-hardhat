import "@nomiclabs/hardhat-waffle";
import "@nomiclabs/hardhat-ethers";
import {HardhatUserConfig} from "hardhat/config";
const config: HardhatUserConfig = {
	defaultNetwork: "hardhat",
	networks: {
		hardhat: {
			gasPrice: 8000000000,
		}
	},
	solidity: {
		version: "0.7.3",
		settings: {
			optimizer: {
				enabled: false,
				runs: 200
			}
		}
	},
	paths: {
		sources: "./contracts",
		tests: "./test",
		cache: "./cache",
		artifacts: "./artifacts"
	}
};
export default config;
