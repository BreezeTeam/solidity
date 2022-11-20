// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Bank {
    uint256 private _lock;// 重入锁
    // 重入锁
    modifier nonReentrant(){
        //在第一次调用 nonReentrant 时，_lock 将是 0
        require(_lock == 0, "nonReentrant!!!");
        //在此之后对 nonReentrant 的任何调用都将失败
        _lock = 1;
        _;
        //在调用结束后，恢复状态
        _lock = 0;
    }

    mapping(address => uint256) balanceOf;
    constructor()  payable{
    }
    // 存款
    function deposit() external payable {
        balanceOf[msg.sender] += msg.value;
    }

    // 无法被攻击
    function withdraw_ok2() external {
        uint256 depositorBalance = balanceOf[msg.sender];
        // 获取余额
        // 判断能够提款
        require(depositorBalance > 0 && depositorBalance <= this.getBalance(), "Insufficient balance");
        // 账户扣钱
        balanceOf[msg.sender] -= depositorBalance;
        // 转账
        (bool success,) = msg.sender.call{value : depositorBalance}("");
        require(success, "withdraw failed");
        if (!success) {
            balanceOf[msg.sender] += depositorBalance;
        }
    }

    // 可以被重入攻击
    // 取款
    // 1. 查看地址的余额
    // 2. 查看银行余额
    // 判断是否能够取钱
    // 先减去账户的钱
    // 进行转账
    function withdraw() external {
        uint256 depositorBalance = balanceOf[msg.sender];
        // 获取余额
        // 判断能够提款
        require(depositorBalance > 0 && depositorBalance <= this.getBalance(), "Insufficient balance");
        // 账户扣钱
        (bool success,) = msg.sender.call{value : depositorBalance}("");
        require(success, "withdraw failed");
        // 转账
        balanceOf[msg.sender] += depositorBalance;
    }


    // 使用重入锁
    function withdraw_ok() external nonReentrant {
        uint256 depositorBalance = balanceOf[msg.sender];
        // 获取余额
        // 判断能够提款
        require(depositorBalance > 0 && depositorBalance <= this.getBalance(), "Insufficient balance");
        // 账户扣钱
        (bool success,) = msg.sender.call{value : depositorBalance}("");
        require(success, "withdraw failed");
        // 转账
        balanceOf[msg.sender] -= depositorBalance;
    }


    // 获取 合约的剩余 eth
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
