// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/TokenSale.sol";

contract TokenSaleTest is Test {
    TokenSale public tokenSale;
    ExploitContract public exploitContract;

    function setUp() public {
        // Deploy contracts
        tokenSale = (new TokenSale){value: 1 ether}();
        exploitContract = new ExploitContract(tokenSale);
        vm.deal(address(exploitContract), 4 ether);
    }

    // Use the instance of tokenSale and exploitContract
    function testIncrement() public {
        // Put your solution here
        uint256 beforeExpolit = address(exploitContract).balance;
        exploitContract.exploit();
        uint256 afterExpolit = address(exploitContract).balance;        
        console.log("got %s, remaining %s", afterExpolit - beforeExpolit, address(tokenSale).balance);

        _checkSolved();
    }

    function _checkSolved() internal {
        assertTrue(tokenSale.isComplete(), "Challenge Incomplete");
    }

    receive() external payable {}
}
