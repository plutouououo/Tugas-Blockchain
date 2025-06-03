// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract MockIDRX is ERC20{
    constructor() ERC20("Indonesian Rupiah Stablecoin", "IDRX") {
        _mint(msg.sender, 1_000_000 * 10**18); // Mint 1M tokens to deployer
    }

    function mint(address to, uint256 amount) public{
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) public{
        _burn(from, amount);
    }
}