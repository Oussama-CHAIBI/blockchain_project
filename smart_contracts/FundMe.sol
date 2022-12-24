// SPDX-License-Identifier: MIT

pragma solidity ^0.6.6;
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

contract fundiMe {
    using SafeMathChainlink for uint256;

    AggregatorV3Interface public priceFeed;

    mapping(address => uint256) public addressToAmountfundied;
    address public owner;
    address[] public fundiers;

    constructor(address _priceFeed) public {
        priceFeed = AggregatorV3Interface(_priceFeed);
        owner = msg.sender;
    }

    //minimum 50$
    function fundi() public payable {
        uint256 minimumUsd = 1 * 10**18;
        require(
            getConversionRate(msg.value) >= minimumUsd,
            "you need to spend more eth"
        );
        addressToAmountfundied[msg.sender] += msg.value;
        fundiers.push(msg.sender);
    }

    function getVersion() public view returns (uint256) {
        return priceFeed.version();
    }

    function getPrice() public view returns (uint256) {
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        return uint256(answer * 10000000000);
    }

    function getConversionRate(uint256 ethAmount)
        public
        view
        returns (uint256)
    {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethAmount * ethPrice) / 1000000000000000000;
        return ethAmountInUsd;
    }

    function getEntranceFee() public view returns (uint256) {
        //minimum usd
        uint256 minimumUSD = 1 * 10**18;
        uint256 price = getPrice();
        uint256 precision = 1 * 10**18;
        return (minimumUSD * precision) / price;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function withdr() public payable onlyOwner {
        msg.sender.transfer(address(this).balance);
        for (
            uint256 fundierIndex = 0;
            fundierIndex < fundiers.length;
            fundierIndex++
        ) {
            address fundier = fundiers[fundierIndex];
            addressToAmountfundied[fundier] = 0;
        }
        fundiers = new address[](0);
    }
}
