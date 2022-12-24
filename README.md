# contracts 合约demo

web3 合约开发学习

本项目中的所有合约使用 foundry 开发

## 创建 foundry 项目

`forge init`

### lib

foundry合约开发框架生成的文件夹

### contracts

foundry合约开发框架需求的合约src文件夹

### foundry.toml 文件内容:

```toml
[profile.default]
src = 'contracts'
out = 'out'
libs = ['lib']
remappings = [
    'solmate-utils/=lib/solmate/src/utils/',
    "ds-test/=lib/forge-std/lib/ds-test/src/",
    "forge-std/=lib/forge-std/src/",
    '@openzeppelin/=lib/openzeppelin-contracts/'
]
```

## hardhat 兼容

使用 remappings 实现，在 foundry.toml 中配置 remappings

### 使用 openzeppelin-contracts:

添加依赖：`forge install openzeppelin/openzeppelin-contracts --no-commit`
remapping:`@openzeppelin/=lib/openzeppelin-contracts/`

### 单元测试 forge-std:

添加依赖：`forge install https://github.com/foundry-rs/forge-std --no-commit`
remapping:`ds-test/=lib/ds-test/src/`

## contracts

### Airdrop

空头合约，一个支持批量转账的合约

### ERC20

定义接口并实现了ERC20标准

### Faucet

水龙头合约

1. 可以通过构造函数，设置发放的ERC20合约地址
2. 用户调用领取函数，可以从合约地址领取到自己的账户上
3. 需要在部署后，手动转账到水龙头合约地址

### reentry

重入攻击学习

### ERC721

定义接口并实现了ERC721,ERC165标准

### DutchAuction

一种简化版的Azuki减价拍卖合约

### MerkleTree

利用MerkleTree合约发放NFT白名单

### SignatureNFT

利用ECDSA签名发放白名单

### NFTSwap

设计实现可可以进行挂单list、撤单revoke、修改价格update，购买purchase，的NFT交易所

### 随机数

使用哈希函数实现链上随机数以及使用chainlink预言机生成链下随机数

### ERC1155

实现了可以一个合约包含多种代币的ERC1155标准

### WETH
为ETH进行合约包装，使ETH满足ERC2标准

## web3学习杂项

### lingAddress

基于clap，ethers-rs开发的靓号生成器

### bot(WIP)

套利机器人

### foundry_stu

学习foundry的demo项目

### hardhat_stu

学习hardhat的demo项目

### dapp_stu

TinTinLab 的课程作业
