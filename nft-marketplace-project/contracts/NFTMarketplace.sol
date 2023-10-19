// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "hardhat/console.sol";

contract NFTMarketplace is ERC721URIStorage {
    using Counters for Counters.Counter;
    // latest minted tokenId
    Counters.Counter private _tokenIds;
    // number of items sold
    Counters.Counter private _itemsSold;

    // marketplace fee to list NFT
    uint256 listingPrice = 0.05 ether;
    // smart contract creator
    address payable smartContractOwner;

    mapping(uint256 => NonFungibleToken) private idToNonFungibleToken;

    struct NonFungibleToken {
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
        uint256 lastSale;
        bool sold;
    }

    event NonFungibleTokenCreated(
        uint256 indexed tokenId,
        address seller,
        address owner,
        uint256 price,
        uint256 lastSale,
        bool sold
    );

    constructor() ERC721("My NFT Marketplace", "MNM") {
        smartContractOwner = payable(msg.sender);
    }

    /* Returns the listing price of the contract */
    function getListingPrice() public view returns (uint256) {
        return listingPrice;
    }

    /* Mints a token and lists it in the marketplace
       payable allows to deposit ETH to contract 
     */
    function mintToken(
        string memory tokenURI,
        uint256 price
    ) public payable returns (uint) {
        require(price >= 0, "NFT Price cannot be negative");
        require(
            msg.value == listingPrice,
            "Transaction fee sent should be equal to listing price"
        );
        // increment token counter
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();

        // mint NFT to address who requested this
        _safeMint(msg.sender, newTokenId);
        // map tokenId to IPFS url
        _setTokenURI(newTokenId, tokenURI);
        // function to emit event and update global variables
        createNonFungibleToken(newTokenId, price);

        return newTokenId;
    }

    function bulkMintTokens(
        string memory tokenBaseURI,
        uint256 price,
        uint256 mintAmount
    ) public payable {
        require(mintAmount > 0, "Specify positive number of NFT to mint");
        require(price >= 0, "NFT Price cannot be negative");
        require(
            msg.value == listingPrice * mintAmount,
            "Transaction fee sent should be equal to listing price * number of nfts to be minted"
        );

        // Iterate 'mintAmount' times to mint NFTs
            // Increment the token counter
            // Mint a new NFT to the address that requested it (msg.sender)
            // Create the metadata URI for the NFT
            // Set the token URI for the NFT with the generated URI
            // Call a function to emit an event and update global variables
        
    }

    function createNonFungibleToken(uint256 tokenId, uint256 price) private {
        // set seller as address that requested NFT to be created
        // set owner the contract address, which indicates that token is not yet bought
        // add additional sale boolean to increase readability
        idToNonFungibleToken[tokenId] = NonFungibleToken(
            tokenId,
            payable(msg.sender),
            payable(address(this)),
            price,
            0,
            false
        );

        // transfer ownership
        _transfer(msg.sender, address(this), tokenId);

        emit NonFungibleTokenCreated(
            tokenId,
            msg.sender,
            address(this),
            price,
            0,
            false
        );
    }

    /* Creates the sale of a marketplace item */
    /* Transfers ownership of the item, as well as funds between parties */
    function buyToken(uint256 tokenId) public payable {
        // Get the price, seller, and sold status of the NFT with the given 'tokenId'
        // Ensure that the NFT is not already sold
        // Ensure that the amount of Ether sent with the transaction matches the NFT's asking price
        // Update the NFT's owner to the buyer (msg.sender)
        // Mark the NFT as sold
        // Set the seller's address to address(0) to indicate that it's no longer owned by the seller
        // Increment a counter to keep track of the number of items sold
        // Transfer ownership of the NFT from the contract to the buyer (msg.sender)
        // Transfer the listing fee to the smart contract owner
        // Transfer the asking price to the seller
    }

    /* Allows someone to resell a token they have purchased 
       payable allows to deposit ETH to contract
    */
    function resellToken(uint256 tokenId, uint256 price) public payable {
        // Check if the caller (msg.sender) is the current owner of the NFT with 'tokenId'
        // Check if the amount of Ether sent with the transaction matches the listing price
        // Store the current price of the NFT as 'lastSale' before updating the price
        // Mark the NFT as not sold (available for purchase)
        // Update the NFT's price to the new 'price'
        // Record the previous sale price as 'lastSale'
        // Set the seller of the NFT to the caller (msg.sender)
        // Set the owner of the NFT to the smart contract's address (address(this))
        // Decrement a counter to indicate that an item has been removed from sale
        // Transfer ownership of the NFT from the seller (msg.sender) to the contract (address(this))
    }

    /* Returns all unsold market items */
    function fetchUnsoldNFTs() public view returns (NonFungibleToken[] memory) {
        uint itemCount = _tokenIds.current();
        uint unsoldItemCount = _tokenIds.current() - _itemsSold.current();
        uint currentIndex = 0;

        NonFungibleToken[] memory items = new NonFungibleToken[](
            unsoldItemCount
        );
        for (uint i = 0; i < itemCount; i++) {
            if (idToNonFungibleToken[i + 1].owner == address(this)) {
                uint currentId = i + 1;
                NonFungibleToken storage currentItem = idToNonFungibleToken[
                    currentId
                ];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }

    /* Returns all market items */
    function fetchAllNFTs() public view returns (NonFungibleToken[] memory) {
        // Get the current total number of NFTs in the collection
        // Initialize a variable to keep track of the current index in the 'items' array
        // Create an array of 'NonFungibleToken' structs with a length of 'itemCount'
        // Iterate through the NFTs in the collection
            // Calculate the current NFT ID by adding 1 to the loop index 'i'
            // Retrieve the NFT with the current ID from the 'idToNonFungibleToken' mapping
            // Assign the retrieved NFT to the 'items' array at the current index
            // Increment the current index for the 'items' array
        // Return the 'items' array, which now contains information about all the NFTs in the collection
        
    }

    /* Returns only items that a user has purchased */
    function fetchMyNFTs() public view returns (NonFungibleToken[] memory) {
        // Get the total number of NFTs in the collection
        // Initialize a variable to count the NFTs owned by the caller
        // Initialize a variable to keep track of the current index in the 'items' array
        // Iterate through all NFTs in the collection
            // Calculate the current NFT ID by adding 1 to the loop index 'i'
            // Check if the owner of the NFT with the current ID is the caller (msg.sender)
                // Increment the 'itemCount' to count NFTs owned by the caller            
        // Create an array of 'NonFungibleToken' structs with a length of 'itemCount'
        // Iterate through all NFTs in the collection again
            // Calculate the current NFT ID by adding 1 to the loop index 'i'
            // Check if the owner of the NFT with the current ID is the caller (msg.sender)
                // Retrieve the NFT with the current ID from the 'idToNonFungibleToken' mapping
                // Assign the retrieved NFT to the 'items' array at the current index
                // Increment the current index for the 'items' array
        // Return the 'items' array, which contains information about NFTs owned by the caller
    }

    /* Function to return the current balance of contract */
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
