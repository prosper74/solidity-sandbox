// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {PriceConverter} from "./PriceConverter.sol";

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 5e18;
    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;
    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        require(msg.value.getConversionRate() >= MINIMUM_USD, "Did not send enough eth");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;        
    }

    function withdraw() public onlyOwner {
        for(uint256 i = 0; i < funders.length; i++) {
            address funder = funders[i];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0); // reset the array

        // Withdraw funds: 3 methods but stick to "call" method
        // transfer (2300 gas): reverts automatically and does not need the require statement
        // payable(msg.sender).transfer(address(this).balance);

        // Send (2300 gas): Does not revert automatically, hence, needs the require statement
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed!");

        // Call (forward all gas): Does not revert automatically, hence, needs the require statement
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed!");
    }

    modifier onlyOwner() {
        // require(msg.sender == i_owner, "Only owner can withdraw");
        if(msg.sender != i_owner) {
            revert NotOwner();
        }
        _;
    }
}
