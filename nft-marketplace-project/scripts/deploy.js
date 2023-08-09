const hre = require("hardhat");

async function main() {
  console.log('Start Smart Contract deployment');

  //Add Missing code here...

  console.log(`NFTMarketplace Address: ${registry.address}`);
}

/* calls main() when node is run directly from command line
   if no more async operations are pending, exits with 0. If exception 
   occurs - exits with error 1 - Uncaught Fatal Exception.
*/
if (require.main === module) {
  main().then(() => process.exit(0))
    .catch(error => { console.error(error); process.exit(1); }); // more descriptive error
}