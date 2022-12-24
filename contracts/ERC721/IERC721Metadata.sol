// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./IERC721.sol";

// IERC721Metadata Contract Interface
// IERC721Metadata 是 ERC721的扩展接口
interface IERC721Metadata is IERC721 {
    // 返回代币名称
    function name() external view returns (string memory);

    // 返回代币代号
    function symbol() external view returns (string memory);

    // 通过tokenId查询metadata的连接URL
    function tokenURI(uint256 tokenId) external view returns (string memory);

}
