# contracts 合约demo

web3 合约开发学习

本项目中的所有合约使用 foundry 开发

## 创建 foundry 项目

`forge init`

## hardhat 兼容

使用 remappings 实现，在 foundry.toml 中配置 remappings

### 使用 openzeppelin-contracts:

添加依赖：`forge install openzeppelin/openzeppelin-contracts --no-commit`
remapping:`@openzeppelin/=lib/openzeppelin-contracts/`

### 单元测试 forge-std:

添加依赖：`forge install https://github.com/foundry-rs/forge-std --no-commit`
remapping:`ds-test/=lib/ds-test/src/`



# lingAddress
基于clap，ethers-rs的 靓号生成器

# bot(WIP)
套利机器人

# foundry_stu
学习foundry的demo项目

# hardhat_stu
学习hardhat的demo项目

# lib
foundry合约开发框架中，用于合于导入lib存储的

# dapp_stu
TinTinLab 的课程作业
