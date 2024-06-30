// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    constructor(string memory name, string memory symbol, uint initialSupply, address send) ERC20(name, symbol) {
        _mint(msg.sender, initialSupply);
        _mint(send, initialSupply);
    }
}