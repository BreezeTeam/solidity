// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from "../ERC20/IERC20.sol";

contract Faucet {

    // when address requested amount,then emit the event
    event SendToken(address indexed receiver, uint256 indexed amount);

    // allow 10 a address
    uint256 amountAllowed = 10;
    // faucet token address
    address public tokenContract;
    // faucet contract address
    address public faucetAddress;
    // requested address
    mapping(address => bool) public requestedAddress;

    // initialize set token address
    constructor(address _contract){
        faucetAddress = msg.sender;
        tokenContract = _contract;
    }

    error faucetExhausted();
    error onlyGetOnce();
    // request Token
    function requestTokens() external {
        if (requestedAddress[msg.sender] == true) {
            revert onlyGetOnce();
        }
        // create v2 create contract
        IERC20 token = IERC20(tokenContract);

        //faucetExhausted
        if (token.balanceOf(address(this)) < amountAllowed) {
            revert faucetExhausted();
        }

        token.transfer(msg.sender, amountAllowed);
        requestedAddress[msg.sender] = true;
        emit SendToken(msg.sender, amountAllowed);
    }
}
