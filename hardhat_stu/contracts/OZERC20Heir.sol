// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract OZERC20Heir is ERC20 {
    constructor() ERC20("OZERC20Heir", "OZHTK") {
        _mint(msg.sender, 1000);
    }
}
