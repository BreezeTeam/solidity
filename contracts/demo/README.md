作业1

1. 修改 EToken 合约，将其修改为 有 重入攻击漏洞的 这个漏洞会导致用户在取出eth burn token时 可以掏空contract里面的eth
2. 写一个单元测试，描述攻击过程
3. 显示调用栈

作业2 使用OW 的ERC721，加上mint 功能

1. free mint 数量值和截止日期，前n位用户可以免费 mint nft 。每个人最多免费mint 3个nft
2. 后来的用户，可以使用 eth 购买 nft，价格必须大于等于设置的 min 价格
3. 并且每个用户只能出不低于前面的用户出过的价格，即，随着mint的出价变化而变化
4. 有一个函数可以用于nft 合约所有者取出卖nft的钱

作业3
https://media.dedaub.com/latent-bugs-in-billion-plus-dollar-code-c2e67a25b689
分析 一下 合约的漏洞和攻击过程