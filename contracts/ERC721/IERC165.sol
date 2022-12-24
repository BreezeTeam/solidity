// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// ERC165 Contract Interface
interface IERC165 {
    // if contract impl interfaceId then return true
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}
