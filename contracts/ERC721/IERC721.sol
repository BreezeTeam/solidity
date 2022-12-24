// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./IERC165.sol";

// ERC721 Contract Interface
interface IERC721 is IERC165 {
    // 在转账时释放，记录token的sender 地址以及 receiver 地址，以及tokenid
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    // 在授权时释放，记录授权地址发出owner，被授权地址 approved，以及tokneid
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    // 在批量授权时释放，记录批量授权发出地址owner，被授权地址 operator，以及被授权与否 approved
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    // 返回某个地址的NFT持有量balance
    function balanceOf(address owner) external view returns (uint256 balance);

    // 返回某个tokenId的所有者
    function ownerOf(uint256 tokenId) external view returns (address owner);

    // 安全转账，如果接收方是合约，需要实现ERC721Receiver接口
    // from 转出地址
    // to 接收地址
    // data 安全转账函数重载函数，里面有一个calldata
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;

    // 安全转账，如果接收方是合约，需要实现ERC721Receiver接口
    // from 转出地址
    // to 接收地址
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    // 普通转账
    // from 转出地址
    // to 接收地址
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    // 授权函数，授权另一个地址使用你的nft
    // to 被授权地址
    // tokenid 被授权nft
    function approve(address to, uint256 tokenId) external;


    // 查询tokenId是否被授权给了某个地址
    function getApproved(uint256 tokenId) external view returns (address operator);


    // 将自己持有的该低劣的NFT批量授权给某个地址
    // 被批量授权地址 operator
    // _approved 是否授权
    function setApprovalForAll(address operator, bool _approved) external;

    // 查询某个owner地址的NFT是否批量授权给了另一个operator地址
    // owner 源地址
    // operator 目标地址
    function isApprovedForAll(address owner, address operator) external view returns (bool);

}
