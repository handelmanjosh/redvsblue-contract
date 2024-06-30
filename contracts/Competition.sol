// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./Token.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Competition is Ownable {
    Token public tokenA;
    Token public tokenB;
    Token public platformToken;
    uint[2] public points;
    struct Pool {
        uint left;
        uint right;
    }
    uint public endTime;
    uint length;
    uint platformTokenAvailable;
    mapping(address => Pool) pools;
    constructor(string memory nameA, string memory symbolA, uint initialSupplyA, string memory nameB, string memory symbolB, uint initialSupplyB) Ownable(msg.sender) {
        tokenA = new Token(nameA, symbolA, initialSupplyA, msg.sender);
        tokenB = new Token(nameB, symbolB, initialSupplyB, msg.sender);
        platformToken = new Token("Platform", "PLATFORM", initialSupplyA, msg.sender);
        pools[address(tokenA)] = Pool({
            left: initialSupplyA / 3,
            right: initialSupplyA
        });
        pools[address(tokenB)] = Pool({
            left: initialSupplyA / 3,
            right: initialSupplyB
        });
        platformTokenAvailable = initialSupplyA / 3;
        length = 2419200; // = 4 weeks
    }
    function start() onlyOwner external {
        endTime = block.timestamp + length;
    }
    function end(address winner, address loser) onlyOwner external {
        // rug loser
        pools[winner].left += pools[loser].left;
        pools[loser].left = 0;
    }
    function transfer(address pool, uint amount, bool leftToRight) external {
        require(amount > 0, "Amount must be greater than 0");
        Pool storage poolData = pools[pool];
        ERC20 p = ERC20(pool);
        ERC20 other = ERC20(platformToken);
        if (leftToRight) {
            require(poolData.left >= amount, "Insufficient balance on the left side");
            poolData.left -= amount;
            poolData.right += amount;
            require(other.transfer(msg.sender, amount), "Transfer failed");
            require(p.transferFrom(msg.sender, address(this), amount), "Transfer failed");
        } else {
            require(poolData.right >= amount, "Insufficient balance on the right side");
            poolData.left += amount;
            poolData.right -= amount;
            require(p.transfer(msg.sender, amount), "Transfer failed");
            require(other.transferFrom(msg.sender, address(this), amount), "Transfer failed");
        }
    }
    function buyPlatformToken(uint amount) external payable {
        require(amount == msg.value, "Incorrect amount");
        ERC20 platform = ERC20(platformToken);
        platform.transfer(msg.sender, amount);
    }
    function sellPlatformToken(uint amount) external {
        ERC20 platform = ERC20(platformToken);
        require(platform.transferFrom(msg.sender, address(this), amount), "Token transfer failed");
        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }
    function addPoints(uint index, uint change) onlyOwner external {
        points[index] += change;
    }
    function viewPoints() external view returns(uint[2] memory p) {
        p = points;
    }
    function viewPool(address a) external view returns(Pool memory p) {
        p = pools[a];
    }
    function viewEndTime() external view returns(uint u) {
        u = endTime;
    }
}