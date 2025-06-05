// SPDX-License-License-Identifier: UNLICENSED
pragma solidity ^0.8.13; // Updated to match contract for consistency

import {Test, console} from "forge-std/Test.sol";
import {MockIDRX} from "../src/IDRXToken.sol";
import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; 

contract IDRXTokenTest is Test {
    MockIDRX public mockIDRX;
    address owner = address(this);
    address user1 = address(0x1);

    function setUp() public {
        mockIDRX = new MockIDRX();
    }

    function testInitialMint() public view {
        uint256 ownerBalance = mockIDRX.balanceOf(owner);
        assertEq(ownerBalance, 1_000_000 * 10**18, "Owner should have 1M tokens");
    }

    function testMintByOwner() public {
        mockIDRX.mint(user1, 1000 * 10**18);
        uint256 user1Balance = mockIDRX.balanceOf(user1);
        assertEq(user1Balance, 1000 * 10**18, "User1 should have 1000 tokens");
    }

    function testBurnByOwner() public {
        mockIDRX.mint(user1, 1000 * 10**18);
        mockIDRX.burn(user1, 500 * 10**18);
        uint256 user1Balance = mockIDRX.balanceOf(user1);
        assertEq(user1Balance, 500 * 10**18, "User1 should have 500 tokens after burn");
    }

}