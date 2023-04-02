pragma solidity ^0.8.0;

contract TokenBatchMinting {
    
    struct TokenData {
        uint256 tokenId;
        string tokenName;
        address owner;
    }
    
    // the Merkle root for the token data
    bytes32 public merkleRoot;
    
    // a mapping to store the token data
    mapping (uint256 => TokenData) public tokenData;
    
    // a function to add token data to the mapping
    function addTokenData(uint256 _tokenId, string memory _tokenName, address _owner) public {
        TokenData memory data = TokenData(_tokenId, _tokenName, _owner);
        tokenData[_tokenId] = data;
    }
    
    // a function to set the Merkle root for the token data
    function setMerkleRoot(bytes32 _merkleRoot) public {
        merkleRoot = _merkleRoot;
    }
    
    // a function to verify the validity of token data using a Merkle proof
    function verifyTokenData(uint256 _tokenId, string memory _tokenName, address _owner, bytes32[] memory proof) public view returns (bool) {
        bytes32 leaf = keccak256(abi.encodePacked(_tokenId, _tokenName, _owner));
        return verifyMerkleProof(merkleRoot, leaf, proof);
    }
    
    // a function to verify a Merkle proof
    function verifyMerkleProof(bytes32 root, bytes32 leaf, bytes32[] memory proof) public pure returns (bool) {
        bytes32 currentHash = leaf;
        for (uint256 i = 0; i < proof.length; i++) {
            bytes32 proofElement = proof[i];
            if (currentHash < proofElement) {
                currentHash = keccak256(abi.encodePacked(currentHash, proofElement));
            } else {
                currentHash = keccak256(abi.encodePacked(proofElement, currentHash));
            }
        }
        return currentHash == root;
    }
}
