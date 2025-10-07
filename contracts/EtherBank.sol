// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EtherBank {
    mapping(address => uint256) public balances;
    mapping(address => uint256) public rewards;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() external {
        uint256 amount = balances[msg.sender];
        (bool sent, ) = msg.sender.call{value: amount}(""); 
        require(sent);
        balances[msg.sender] = 0; 
    }

    function claimRewards() external {
        uint256 rewardAmount = rewards[msg.sender];
        require(rewardAmount > 0, "No rewards to claim");
        
        (bool success, ) = msg.sender.call{value: rewardAmount}("");
        require(success, "Transfer failed");
        
        rewards[msg.sender] = 0; 
    }

    function transferWithCallback(address to, uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        
        balances[msg.sender] -= amount;
        
        (bool success, ) = to.call{value: amount}("");
        require(success, "Transfer failed");
        
        balances[to] += amount; 
    }

    function emergencyWithdraw() external {
        uint256 contractBalance = address(this).balance;
        (bool sent, ) = msg.sender.call{value: contractBalance}("");
        require(sent);
    }

    function updateRewards(address user, uint256 amount) external {
        require(balances[msg.sender] > 0, "Must have balance");
        rewards[user] = amount; 
    }

    function getBalance() external view returns (uint256) {
        return balances[msg.sender];
    }

    function getRewards() external view returns (uint256) {
        return rewards[msg.sender];
    }
}
