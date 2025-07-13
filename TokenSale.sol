// SPDX-License-Identifier: MIT
pragma solidity ^0.4.24;

contract TokenSale {
    mapping(address => uint256) public balances;
    uint256 public tokenPrice = 1 ether;

    function buyTokens(uint256 amount) public payable {
        require(msg.value == amount * tokenPrice); // no overflow protection
        balances[msg.sender] += amount;
    }

    function checkBalance() public view returns (uint256) {
        return balances[msg.sender];
    }
}
