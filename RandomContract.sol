// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/smartcontractkit/chainlink-brownie-contracts/blob/main/contracts/src/v0.8/VRFConsumerBase.sol";

contract AIGenFT is ERC721URIStorage, Ownable, VRFConsumerBase {
    uint256 public totalSupply;
    uint256 public maxSupply;
    uint256 public mintPrice = 0.01 ether;
    uint256 public fee;
    bytes32 keyHash;
    
    bool public mintingEnabled; 
    mapping (address => uint256) public mintedWallets;
    mapping (bytes32 => string) public requestIDToTokenURI;
    mapping (bytes32 => address) public requestIDtoSender;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIDCounter;
    event requestedCollectible(bytes32 indexed requestID);
    
    constructor(address _VRFConsumerBase, address _LinkToken, bytes32 _keyhash) 
    VRFConsumerBase(_VRFConsumerBase, _LinkToken)
    payable ERC721("BurnCollection", "WBC") 
    {
        _keyhash = keyHash;
        fee = .1 * 10 ** 18;
        maxSupply = 2;
    }
    
    function toggleMinting() 
    external onlyOwner {
        mintingEnabled != mintingEnabled;
    }

    function setMaxSupply(uint256 _maxSupply) 
    external onlyOwner{
        maxSupply = _maxSupply;
    }

    function createToken(uint256 userProvidedSeed, string memory tokenURI) 
    external payable returns (bytes32) {      
        _tokenIDCounter.increment();
        bytes32 requestID = requestRandomness(keyHash, fee);
        uint256 newItemID = _tokenIDCounter.current();
        requestIDtoSender[requestID] = msg.sender;
        requestIDToTokenURI[requestID] = tokenURI;
        emit requestedCollectible(requestID);
        require(mintingEnabled, "Minting is currently disabled");
        require(totalSupply <= maxSupply ,"Exceeded maximum supply of tokens");
        require (msg.value == mintPrice, "Price mismatch");
        require (mintedWallets[msg.sender] < 1 , "Only 1 token can be minted per wallet");
        _safeMint(msg.sender, newItemID);
        _setTokenURI(newItemID, tokenURI);        
        mintedWallets[msg.sender]++;
        //return newItemID;
    } 
 
    function fulfillRandomness(bytes32 requestID, uint randomNumber) internal override {
        address origin = requestIDtoSender[requestID];
        string memory tokenURI = requestIDToTokenURI[requestID];
        uint256 uniqueID = _tokenIDCounter.current();
        _safeMint(origin, uniqueID);
        _setTokenURI(uniqueID, tokenURI);

    }
 
 }

