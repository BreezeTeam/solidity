// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// IERC721Receiver Contract Interface
// 合约必须实现该接口才能通过安全转账接收ERC721
interface IERC721Receiver {
    function onIERC721Received(
        address operator,
        address from,
        uint tokenId,
        bytes calldata data
    ) external returns (bytes4);
}
