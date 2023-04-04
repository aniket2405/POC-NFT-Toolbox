/*

We use a mapping to store NFT objects that can contain other NFTs as sub-assets. 
We use the struct "NFT" to represent the properties and attributes of an NFT, 
and include a mapping to store any sub-NFTs associated with each NFT. 

The contract includes functions for creating NFTs with sub-assets, 
creating sub-assets associated with existing NFTs, setting metadata for NFTs and sub-assets, 
retrieving sub-assets associated with an NFT, and retrieving the URI for an NFT.

*/

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NestedNFT is ERC721 {
    struct NFT {
    uint256 id;
    uint256[] subNFTIds;
    string name;
    string symbol;
    string uri;
    mapping (uint256 => NFT) subNFTs;
    }
    
    mapping (uint256 => NFT) public nfts;
    uint256 public nextNFTId;

    constructor() ERC721("Nested NFT", "NNFT") {}

    function createNFT(string memory name, string memory symbol, string memory uri, uint256[] memory subNFTIds) public {
        uint256 nftId = nextNFTId;
        nfts[nftId] = NFT(nftId, subNFTIds, name, symbol, uri);
        _safeMint(msg.sender, nftId);
        nextNFTId++;
    }

    function createSubNFT(uint256 nftId, string memory name, string memory symbol, string memory uri, uint256[] memory subNFTIds) public {
        require(_exists(nftId), "NFT does not exist");
        uint256 subNFTId = nextNFTId;
        nfts[nftId].subNFTs[subNFTId] = NFT(subNFTId, subNFTIds, name, symbol, uri);
        nextNFTId++;
    }

    function setNFTMetadata(uint256 nftId, string memory name, string memory symbol, string memory uri) public {
        require(_exists(nftId), "NFT does not exist");
        nfts[nftId].name = name;
        nfts[nftId].symbol = symbol;
        nfts[nftId].uri = uri;
    }

    function setSubNFTMetadata(uint256 nftId, uint256 subNFTId, string memory name, string memory symbol, string memory uri) public {
        require(_exists(nftId), "NFT does not exist");
        require(nfts[nftId].subNFTs[subNFTId].id != 0, "Sub-NFT does not exist");
        nfts[nftId].subNFTs[subNFTId].name = name;
        nfts[nftId].subNFTs[subNFTId].symbol = symbol;
        nfts[nftId].subNFTs[subNFTId].uri = uri;
    }

    function getSubNFTs(uint256 nftId) public view returns (uint256[] memory) {
        require(_exists(nftId), "NFT does not exist");
        return nfts[nftId].subNFTIds;
    }

    function tokenURI(uint256 nftId) public view override returns (string memory) {
        require(_exists(nftId), "NFT does not exist");
        return nfts[nftId].uri;
    }
}
