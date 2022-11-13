# windows install and setup
1. 安装 foundry `cargo install --git https://github.com/foundry-rs/foundry foundry-cli anvil --bins --locked`
2. 创建一个项目 `forge init  foundry_stu --no-commit`
3. 从一个模板构建项目` forge init --template https://github.com/foundry-rs/forge-template hello_template`
4. Working on an Existing Project 
5. `git clone https://github.com/abigger87/femplate`
6. build :`forge build`
7. test:`forge test`
8. add dependency `forge install transmissions11/solmate --no-commit`
9. Remapping dependencies `forge remappings`
10. update dependency `forge update lib/solmate`

tips: 在 build之前需要先安装依赖,例如单元测试的依赖（大多数时候都会自动安装依赖）
`forge install https://github.com/foundry-rs/forge-std --no-commit`

### Test
1. Forge 将在您的源目录中的任何地方查找测试。任何与以测试开始的函数的契约都被认为是测试。
通常，测试将按照约定放置在 src/test 中，并以 .t.sol 结尾
2. 匹配 合约或者测试函数名 测试 `forge test --match-contract ComplicatedContractTest --match-test testDeposit`
3. 匹配文件名字测试  forge test --match-path test/ContractB.t.sol
4. -vvvvvv 来显示详细信息
5. tdd `forge test --watch` 或者`forge test --watch --run-all`
6. bug:
```javascript
No tests match the provided pattern:
        match-path: `D:\Project\solidity\hello_foundry\src\Counter.t.sol`

```
7. https://book.getfoundry.sh/forge/cheatcodes

## debug
https://book.getfoundry.sh/forge/debugger
forge test --debug testIncrement --match-contract CounterTest

