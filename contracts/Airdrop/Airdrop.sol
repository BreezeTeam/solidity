// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import {IERC20} from "../ERC20/IERC20.sol";
import {ERC20} from "../ERC20/ERC20.sol";

contract Airdrop {
    error needApproveMoreAmount(address spender, uint amount);
    error callDataError();

    // ERC2O token address
    // _address airdrop token address array
    // _amounts airdrop token amount array
    function airdrop(
        address _token,
        address[] calldata _addresses,
        uint256[] calldata _amounts
    ) external {
        if (_addresses.length != _amounts.length) {
            revert callDataError();
        }
        // constructor IERC20
        IERC20 token = IERC20(_token);
        uint totalAmounts = sum(_amounts);
        // check approve token sum
        // msg.sender approve to address(this)
        if (token.allowance(msg.sender, address(this)) < totalAmounts) {
            revert needApproveMoreAmount(msg.sender, totalAmounts);
        }
        for (uint i = 0; i < _amounts.length; i++) {
            // token.allowance[_sender is param msg.sender][call address that is address(this)];
            token.transferFrom(msg.sender, _addresses[i], _amounts[i]);
        }
    }


    // sum internal function
    function sum(uint256[] memory _array) pure internal returns (uint256) {
        uint256 total = 0;
        for (uint i = 0; i < _array.length; i++) {
            total += _array[i];
        }
        return total;
    }
}