// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract AIGenFT is ERC721URIStorage, Ownable {
    uint256 public totalSupply;
    uint256 public maxSupply;
    uint256 public mintPrice = 0.01 ether;
    bool public mintingEnabled; 
    mapping (address => uint256) public mintedWallets;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIDCounter;
  
    constructor() payable ERC721("BurnCollection","WBC") {
        maxSupply = 2;
    }
    
    function toggleMinting() external onlyOwner {
        mintingEnabled != mintingEnabled;
    }

    function setMaxSupply(uint256 _maxSupply) external onlyOwner{
        maxSupply = _maxSupply;
    }

    function createToken(string memory tokenURI) external payable returns (uint256) {      
        _tokenIDCounter.increment();
        uint256 newItemID = _tokenIDCounter.current();
        require(mintingEnabled, "Minting is currently disabled");
        require(totalSupply <= maxSupply ,"Exceeded maximum supply of tokens");
        require (msg.value == mintPrice, "Price mismatch");
        require (mintedWallets[msg.sender] < 1 , "Only 1 token can be minted per wallet");
        _safeMint(msg.sender, newItemID);
        _setTokenURI(newItemID, tokenURI);        
        mintedWallets[msg.sender]++;

        return newItemID;
    } 
 }
