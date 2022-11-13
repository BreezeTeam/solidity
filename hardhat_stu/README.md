
# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a script that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.ts
```

# 安装 hardhat
# reference:https://hardhat.org/tutorial/setting-up-the-environment
# refrence:https://hardhat.org/tutorial/creating-a-new-hardhat-project


npm install -g yarn
yarn init
yarn add hardhat 
npm install   @nomicfoundation/hardhat-toolbox
yarn add  @nomicfoundation/hardhat-toolbox

# 使用 hardhat

compile：yarn hardhat compile
test：yarn hardhat test
deploy: yarn hardhat run scripts/deploy.ts --network goerli  


### 测试合约功能

sol 代码
```solidity
    error onlyOwnerError(address sender);
    // only owner
    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert onlyOwnerError(msg.sender);
        }
        _;
    }

    event NewOwner(address newOwner);

    // 转换 所有者
    function transferOwnerShip(address _newOwner) external onlyOwner {
        owner = _newOwner;
        emit NewOwner(_newOwner);
    }

```

测试代码
```ts
    describe("OwnerShip", function () {
        it("OwnerShip transfer to new Owner", async function () {
            const { token, owner, addr1, addr2 } = await loadFixture(deployLoadFixture);
            const newOwner = addr2;
            

            // transfer
            await token.transferOwnerShip(newOwner.address);

            // check owner ship
            expect(await token.owner()).to.hexEqual(newOwner.address);
            await expect(
                // 想换回原来的 所有者
                token.connect(owner).transferOwnerShip(owner.address)
            ).to.be.revertedWithCustomError(
                token, "onlyOwnerError"
            );
        });

    });
```

执行命令

```bash
yarn hardhat compile
yarn hardhat test
```

测试结果

``` bash
    OwnerShip
      ✔ OwnerShip transfer to new Owner (114ms)
```


### 部署一个合约


sol：
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract OZERC20Heir is ERC20 {
    constructor() ERC20("OZERC20Heir", "OZHTK") {
        _mint(msg.sender, 1000);
    }
}

```
deploy 脚本
```ts
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
deploy2().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});

```
执行命令
```bash
 hardhat run scripts/deploy.ts --network goerli
```

输出结果
```bash
yarn run v1.22.19
$ hardhat run scripts/deploy.ts --network goerli
Deploying contracts with the account: 0x4dbDCA5e31DeF5250aBdb9ea7a4E9b6833d382FdAccount balance: 554040686065201815
hardhat token deployed to 0x02e3822Bb8Dd1FB8568C4Aeb55109Fb02a389B01
Done in 38.23s.
```
tips 准备工作
1. yarn add @openzeppelin/contracts
2. npm install @openzeppelin/contracts
3. 编写solidity 后 yarn hardhat compile


### verify
需要进行配置

yarn hardhat verify --contract contracts/OZERC20Heir.sol:OZERC20Heir --network goerli 0x02e3822Bb8Dd1FB8568C4Aeb55109Fb02a389B01