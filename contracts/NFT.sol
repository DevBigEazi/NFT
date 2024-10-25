// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.27;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTMarket is ERC721, Ownable {
    enum OrderStatus {
        None,
        Created,
        Pending,
        Sold
    }

    struct Asset {
        string name;
        uint16 price;
        OrderStatus status;
    }

    Asset[] public assets;
    mapping(uint256 => bool) public isSold;

    event AssetListed(
        string indexed name,
        uint16 price,
        uint256 indexed tokenId
    );
    event AssetSold(
        string indexed name,
        uint16 price,
        address indexed buyer,
        uint256 indexed tokenId
    );

    constructor() ERC721("DMark", "DMK") {}

    function createItem(string memory _name, uint16 _price) external onlyOwner {
        require(msg.sender != address(0), "Zero address is not allowed");
        require(_price > 0, "Price must be greater than zero");

        Asset memory newAsset = Asset({
            name: _name,
            price: _price,
            status: OrderStatus.Created
        });

        assets.push(newAsset);
        uint256 tokenId = assets.length - 1;

        _mint(owner(), tokenId);

        emit AssetListed(_name, _price, tokenId);
    }

    function purchaseItem(uint8 _index) external payable {
        require(_index < assets.length, "Out of bound!");
        Asset storage asset = assets[_index];

        require(
            asset.status == OrderStatus.Created,
            "Asset is not available for sale"
        );
        require(msg.value == asset.price, "Incorrect amount sent");

        asset.status = OrderStatus.Sold;
        isSold[_index] = true;

        _transfer(owner(), msg.sender, _index);

        (bool sent, ) = owner().call{value: msg.value}("");
        require(sent, "Failed to send Ether");

        emit AssetSold(asset.name, asset.price, msg.sender, _index);
    }
}