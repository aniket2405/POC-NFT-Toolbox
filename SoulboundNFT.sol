// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract SoulboundNFT is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    
    struct NftData {
        uint256 id;
        address owner;
        bool soulbound;
    }
    
    mapping (uint256 => NftData) private _nftData;
    
    constructor() ERC721("SoulboundNFT", "SNFT") {}
    
    function mint(address to, bool soulbound) external returns (uint256) {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(to, newItemId);
        
        NftData memory nft;
        nft.id = newItemId;
        nft.owner = to;
        nft.soulbound = soulbound;
        _nftData[newItemId] = nft;
        
        return newItemId;
    }
    
    function isSoulbound(uint256 tokenId) external view returns (bool) {
        return _nftData[tokenId].soulbound;
    }
    
    function setSoulbound(uint256 tokenId, bool soulbound) external {
        require(_isApprovedOrOwner(msg.sender, tokenId), "SoulboundNFT: caller is not owner nor approved");
        _nftData[tokenId].soulbound = soulbound;
    }
}
