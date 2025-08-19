// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {PriceConverter} from "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;

    uint256 public minimumUSD = 5e18;
    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    function fund() public payable {
        require(msg.value.getConversionRate() >= minimumUSD, "Did not send enough eth");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;        
    }

    function withdraw() public {
        for(uint256 i = 0; i < funders.length; i++) {
            address funder = funders[i];
            addressToAmountFunded[funder] = 0;
        }
    }
}
