const MAX_BATCH_SIZE = 1000;
const batchSize = 500;
const tokenData = []; // array of token data to be minted

// Split token data into batches
const batches = [];
for (let i = 0; i < tokenData.length; i += batchSize) {
  batches.push(tokenData.slice(i, i + batchSize));
}

// Create a Merkle tree for each batch
const merkleTrees = batches.map(batch => new MerkleTree(batch));

// Calculate the Merkle root for each tree
const merkleRoots = merkleTrees.map(tree => tree.getRoot());

// Store the Merkle roots on the blockchain
for (let i = 0; i < merkleRoots.length; i++) {
  const tx = await contract.setMerkleRoot(merkleRoots[i]);
  await tx.wait();
}

// Mint tokens in batches using the Merkle proofs
for (let i = 0; i < batches.length; i++) {
  const tokenIds = batches[i].map(token => token.id);
  const proofs = batches[i].map(token => merkleTrees[i].getProof(token));

  // Mint tokens using the batchMintNFTs function
  const tx = await contract.batchMintNFTs(tokenIds, proofs);
  await tx.wait();
}
