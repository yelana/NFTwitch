pragma solidity ^0.8.7;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol";

contract AIGenFT is ERC721URIStorage {
    uint256 public tokenCounter;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIDCounter;

    constructor() ERC721("Filler","FIL") {}
    
    function createToken(string memory tokenURI) public returns (uint256) {        
        _tokenIDCounter.increment();
        uint256 newItemID = _tokenIDCounter.current();
        _safeMint(msg.sender, newItemID);
        _setTokenURI(newItemID, tokenURI);        
        return newItemID;
    }
    
 }
