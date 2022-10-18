// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract Ticket is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private currentId;

    bool public saleIsActive = false;
    uint256 public totalTickets = 10;
    uint256 public availableTickets = 10;
    uint256 public mintPrice = 80000000000000000;

    mapping(address => uint256[]) public holderTokenIDs;
    mapping(address => bool) public checkIns;

    constructor() ERC721("NFTicket", "NFTI") {
        currentId.increment();
    }

    function checkIn(address addy) public {
        require(holderTokenIDs[addy].length > 0, "You dont have any ticket");
        checkIns[addy] = true;
        uint256 tokenId = holderTokenIDs[addy][0];


        string memory tokenURI = "Cheked In";

        _setTokenURI(tokenId, tokenURI);
    }

    function mint() public payable {
        require(availableTickets > 0, "Not enough tickets");
        require(msg.value >= mintPrice, "Not enough ETH!");
        require(saleIsActive, "Tickets are not on sale!");

        string memory tokenURI = "https://ipfs/ticket";

        _safeMint(msg.sender, currentId.current());
        _setTokenURI(currentId.current(), tokenURI);

        holderTokenIDs[msg.sender].push(currentId.current());
        currentId.increment();
        availableTickets = availableTickets - 1;
    }

    function availableTicketCount() public view returns (uint256) {
        return availableTickets;
    }

    function totalTicketCount() public view returns (uint256) {
        return totalTickets;
    }

    function openSale() public onlyOwner {
        saleIsActive = true;
    }

    function closeSale() public onlyOwner {
        saleIsActive = false;
    }

    function confirmOwnership(address addy) public view returns (bool) {
        return holderTokenIDs[addy].length > 0;
    }

}
