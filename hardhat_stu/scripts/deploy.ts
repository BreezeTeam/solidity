import { config } from "dotenv";
import { ethers } from "hardhat";


async function deploy1() {
    const Token = await ethers.getContractFactory("contracts/ERC20.sol:ERC20");
    const [owner, addr1, addr2] = await ethers.getSigners();

    console.log("Deploying contracts with the account:", owner.address);
    console.log("Account balance:", (await owner.getBalance()).toString());


    // token 名称
    const name = "ETK";
    const symbol = "ETK";
    const token = await Token.deploy(name, symbol);
    await token.deployed();

    console.log(`hardhat token deployed to ${token.address}`);
}

async function deploy2() {
    const Token = await ethers.getContractFactory("OZERC20Heir");
    const [owner, addr1, addr2] = await ethers.getSigners();

    console.log("Deploying contracts with the account:", owner.address);
    console.log("Account balance:", (await owner.getBalance()).toString());


    // token 名称
    const token = await Token.deploy();
    await token.deployed();

    console.log(`hardhat token deployed to ${token.address}`);
}
// async function verify(params:type) {

//   if (network.config.chainId === 4 && process.env.ETHERSCAN_API_KEY) {
//     console.log("Waiting for block confirmations...")
//     await hardhatToken.deployTransaction.wait(1)
//     await verify(hardhatToken.address, [])
//   }

// }

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.


deploy1().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

deploy2().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
