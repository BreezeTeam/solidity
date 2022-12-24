// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract ENFT is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    Counters.Counter private _freeMintUserIdCounter;
    mapping(address => uint256) private _userFreeMintMapping;


    uint256 start;
    uint256 daysAfter;
    uint256 minPrice;

    uint256 MAX_SUPPLY = 100000; // total max supply
    uint256 USER_MAX_FREE_COUNT = 3;
    uint256 MAX_FREE_MINT_USER_SUPPLY = 100;

    // 初始化时需要给出free mint 的截至日期,地板价,免费mint 人数限制
    constructor(uint256 _daysAfter, uint256 _minPrice, uint256 _max_free_mint_user) ERC721("ENFT", "ENFT") {
        start = block.timestamp;
        daysAfter = _daysAfter;
        minPrice = _minPrice;
        MAX_FREE_MINT_USER_SUPPLY = _max_free_mint_user;
    }
    function freeSafeMint(address to, string memory uri) public payable {
        require(_tokenIdCounter.current() <= MAX_SUPPLY, "I'm sorry we reached the cap");
        if (msg.value == 0 && _freeMintUserIdCounter.current() <= MAX_FREE_MINT_USER_SUPPLY &&
            block.timestamp >= start + daysAfter * 1 days
        ) {
            require(_userFreeMintMapping[to] < USER_MAX_FREE_COUNT, "I'm sorry, you are not qualified for free mint anymore");
            // add free mint count
            _userFreeMintMapping[to] += 1;
            // wen user first free mint ,inc
            if (_userFreeMintMapping[to] == 1) {
                _freeMintUserIdCounter.increment();
            }
        } else {
            require(msg.value >= minPrice, "I'm sorry, your price is too low");
            minPrice = msg.value;
        }

        // final interaction
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    // only projects owner
    function withdraw() public onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
    internal
    override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
    public
    view
    override(ERC721, ERC721URIStorage)
    returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
    public
    view
    override(ERC721, ERC721Enumerable)
    returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
