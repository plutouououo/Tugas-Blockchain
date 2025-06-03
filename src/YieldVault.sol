//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract YieldVault is ERC20 {
    error ZeroAmount();
    error NotEnoughShares();
    error NothingShares();

    event Deposit(
        address indexed account,
        uint256 amount,
        uint256 shares,
        uint256 totalAssets
    );

    event Withdraw(
        address indexed account,
        uint256 sharesBurned,
        uint256 tokenWithdraw,
        uint256 newTotalAssets,
        uint256 newUserShares
    );

    IERC20 public immutable token;
    uint256 public totalAssets;

    constructor(address _token) ERC20("Yield Vault", "YVault") {
        token = IERC20(_token);
    }

    modifier nonZero(uint256 value) {
        if (value == 0) revert ZeroAmount();
        _;
    }

    function deposit(uint256 amount) public nonZero(amount) returns (uint256) {
        require(token.allowance(msg.sender, address(this)) >= amount, "Insufficient allowance");

        uint256 shares;
        uint256 totalShares = totalSupply();
        uint256 oldTotalAssets = totalAssets;
        totalAssets += amount;

        if (totalShares == 0) {
            shares = amount;
        } else {
            shares = (amount * totalShares) / oldTotalAssets;
        }

        _mint(msg.sender, shares);
        token.transferFrom(msg.sender, address(this), amount);
        emit Deposit(msg.sender, amount, shares, totalAssets);

        return shares;
    }

    function withdraw(uint256 shares) public nonZero(shares) {
        if (shares > balanceOf(msg.sender)) revert NotEnoughShares();

        uint256 totalShares = totalSupply();
        if (totalShares == 0) revert NothingShares();

        uint256 amount = (shares * totalAssets) / totalShares;
        totalAssets -= amount;

        _burn(msg.sender, shares);
        token.transfer(msg.sender, amount);

        emit Withdraw(msg.sender, shares, amount, totalAssets, balanceOf(msg.sender));
    }

    function getYield(address account) public view returns (uint256) {
        uint256 userShares = balanceOf(account);
        if (userShares == 0) return 0;

        uint256 totalShares = totalSupply();
        if (totalShares == 0) return 0;

        // This function counting asset from user in vault based on shares and return 5% from asset as yield dummy.
        uint256 userAssets = (userShares * totalAssets) / totalShares;
        uint256 yield = (userAssets * 5) / 100; // 5% dari saldo user
        return yield;
    }
}