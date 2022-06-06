// SPDX-License-Identifier: MIT

interface IERC721 {
    function transferFrom(
        address _from,
        address _to,
        uint _nftId
    ) external;
}


pragma solidity ^0.8.14;

contract dutchAuction {

    IERC721 public immutable nft;
    uint public immutable nftId;
    address payable public immutable seller;
    uint256 public immutable endDate;
    uint256 public immutable startingPrice;
    uint256 public immutable startDate;

    constructor(
        address _nft,
        uint _nftId,
        uint256 _startDate,
        uint256 _endDate,
        uint256 _startingPrice
    ) {
        seller = payable(msg.sender);
        require(_startDate < _endDate, "Invalid date range");
        startDate = _startDate;
        endDate = _endDate;
        startingPrice = _startingPrice;

        nft = IERC721(_nft);
        nftId = _nftId;
    }

    /*
        Solving the equation
    */
    function getCurrentPrice(uint256 date) public view returns (uint256) {
        require((date >= startDate) && (date < endDate), "Invalid date");
        return (endDate - date) * startingPrice / (endDate - startDate);
    }

    function buy() external payable {
        require(startDate < endDate, "This Auction has ended");

        uint price = getCurrentPrice(block.timestamp);
        require(msg.value >= price, "The amount of ETH sent is less than the price of token");

        nft.transferFrom(seller, msg.sender, nftId);
        uint refund = msg.value - price;
        if (refund > 0) {
            payable(msg.sender).transfer(refund);
        }
        selfdestruct(seller);
    }
}