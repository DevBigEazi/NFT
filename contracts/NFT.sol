// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.27;

contract NFTMarket {
    address public owner;
    address public buyer;

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

    event AssetListed(string indexed name, uint16 price);
    event AssetSold(string indexed name, uint16 price, address buyer);

    constructor() {
        owner = msg.sender;
    }

    function listOrder(string memory _name, uint16 _price) external {
        require(msg.sender != address(0), "Zero address is not allowed");

        Asset memory newAsset;
        newAsset.name = _name;
        newAsset.price = _price;
        newAsset.status = OrderStatus.Created;

        assets.push(newAsset);

        emit AssetListed(_name, _price);
    }

    function buyOrder(uint8 _index) external {
        require(msg.sender != address(0), "Zero address is not allowed");
        require(_index < assets.length, "Out of bound!");
        require(!isSold[_index], "Asset already sold");

        
        assets[_index].status = OrderStatus.Sold;
        isSold[_index] = true;
        buyer = msg.sender;

        emit AssetSold(assets[_index].name, assets[_index].price, msg.sender);
    }
}