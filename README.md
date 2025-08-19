** Price Converter Library **
1. getPrice Function: Gets the latest eth price using Chainlink API
2. getConversionRate function converts the funded amount to wei, using the latest eth price and returns the price in USD

** FundMe Contract **
1. Require users to fund a minimum of 5usd, and revert the operation if the amount is less.
2. Stores the funders address and the amount funded in a list of address and a map
