// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {YieldVault} from "../src/YieldVault.sol";
import {MockIDRX} from "../src/IDRXToken.sol";
import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract YieldVaultTest is Test {
    YieldVault public yieldVault;
    MockIDRX public mockIDRX;

    function setUp() public {
        mockIDRX = new MockIDRX();
        yieldVault = new YieldVault(address(mockIDRX));
    }

    function test_deposit() public {
        mockIDRX.mint(address(this), 1_000_000 * 10**18); // Mint 1 juta token
        mockIDRX.approve(address(yieldVault), 1_000_000 * 10**18);
        yieldVault.deposit(1_000_000 * 10**18);
        assertEq(yieldVault.totalAssets(), 1_000_000 * 10**18, "Total assets should match deposit amount");
        console.log("Balance of shares:", yieldVault.balanceOf(address(this)));
    }

    function test_withdraw() public {
        mockIDRX.mint(address(this), 1_000_000 * 10**18); // Mint 1 juta token
        mockIDRX.approve(address(yieldVault), 1_000_000 * 10**18);
        yieldVault.deposit(1_000_000 * 10**18);
        assertEq(yieldVault.totalAssets(), 1_000_000 * 10**18, "Total assets should match deposit amount");

        // Store the initial share balance
        uint256 initialShares = yieldVault.balanceOf(address(this));
        console.log("Initial shares:", initialShares);

        // Withdraw half of your shares
        uint256 halfShares = initialShares / 2;
        yieldVault.withdraw(halfShares); // Changed from Withdraw to withdraw
        console.log("Remaining shares:", yieldVault.balanceOf(address(this)));

        // Withdraw remaining shares
        yieldVault.withdraw(yieldVault.balanceOf(address(this)));
        assertEq(yieldVault.totalAssets(), 0, "Total assets should be 0 after full withdrawal");
    }

    function test_getYield() public {
        mockIDRX.mint(address(this), 2_000_000 * 10**18); // Mint 2 juta token
        mockIDRX.approve(address(yieldVault), 2_000_000 * 10**18);
        yieldVault.deposit(2_000_000 * 10**18);

        // Verifikasi yield (5% dari 2.000.000 = 100.000)
        uint256 yield = yieldVault.getYield(address(this));
        assertEq(yield, 100_000 * 10**18, "Yield should be 5% of user assets");
        console.log("Yield for user:", yield);
    }

    function test_error_deposit() public {
        vm.expectRevert(YieldVault.ZeroAmount.selector);
        yieldVault.deposit(0);
    }

    function test_error_withdraw() public {
        mockIDRX.mint(address(this), 1_000_000 * 10**18); // Mint 1 juta token
        mockIDRX.approve(address(yieldVault), 1_000_000 * 10**18);
        yieldVault.deposit(1_000_000 * 10**18);
        console.log("Balance of shares:", yieldVault.balanceOf(address(this)));
        
        vm.expectRevert(YieldVault.NotEnoughShares.selector);
        yieldVault.withdraw(1_500_000 * 10**18); // Changed from Withdraw to withdraw
    }
}