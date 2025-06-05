// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {YieldVault} from "../src/YieldVault.sol";
import {MockIDRX} from "../src/IDRXToken.sol";

contract DeployYieldVaultScript is Script {
    YieldVault public yieldVault;
    MockIDRX public mockIDRX;
    uint256 forkId;

    //function setUp() public {
    //    string memory rpc = vm.envString("SEPOLIA_RPC_URL");
    //    forkId = vm.createSelectFork(rpc);
    //}

    function run() public {
        //uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        //vm.startBroadcast(deployerPrivateKey);
        vm.startBroadcast();

        // Deploy contracts
        mockIDRX = new MockIDRX();
        yieldVault = new YieldVault(address(mockIDRX));

        console.log("YieldVault deployed at", address(yieldVault));
        console.log("MockIDRX deployed at", address(mockIDRX));

        vm.stopBroadcast();
    }
}