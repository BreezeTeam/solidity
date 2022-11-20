// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/console.sol";
import "forge-std/Test.sol";
import "forge-std/Vm.sol";
import "./Attack.sol";
import "./Bank.sol";


contract AttackTest is DSTest {
    Attack public attack;
    Bank public bank;

    function setUp() public {
        bank = new Bank{value : 10 ether}();
        attack = new Attack(bank);
    }

    function testBalance() public view {
        console2.log(bank.getBalance());
        console2.log(attack.getBalance());
        assert(bank.getBalance() == 10 ether);
    }

    function testAttack() public {
        attack.attack{value : 1 ether}();
    }
}
