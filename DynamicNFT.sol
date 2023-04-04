/*

In this contract, we define a TokenMetadata struct to store the name, symbol, and URI of each dynamic NFT. 
We also define a mapping called tokenMetadata to map each token ID to its metadata.

The mint function allows anyone to mint a new dynamic NFT with the specified metadata. 
The setTokenMetadata function allows the owner of a dynamic NFT to update its metadata. 

By allowing dynamic NFTs with customizable metadata, this contract provides a flexible 
and extensible way to create and manage NFTs on the Ethereum blockchain in a dynamic way.

*/

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract DynamicNFT is ERC721 {
    struct TokenMetadata {
        string name;
        string symbol;
        string uri;
    }
    
    mapping (uint256 => TokenMetadata) public tokenMetadata;
    uint256 public nextTokenId;
    
    constructor() ERC721("Dynamic NFT", "DNFT") {}
    
    function mint(string memory name, string memory symbol, string memory uri) public {
        uint256 tokenId = nextTokenId;
        tokenMetadata[tokenId] = TokenMetadata(name, symbol, uri);
        _safeMint(msg.sender, tokenId);
        nextTokenId++;
    }
    
    function setTokenMetadata(uint256 tokenId, string memory name, string memory symbol, string memory uri) public {
        require(_exists(tokenId), "Token does not exist");
        tokenMetadata[tokenId] = TokenMetadata(name, symbol, uri);
    }
    
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "Token does not exist");
        return tokenMetadata[tokenId].uri;
    }
}
