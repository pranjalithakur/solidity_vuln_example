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
        (bool sent, ) = msg.sender.call{value: amount}(""); // call before state update
        require(sent);
        balances[msg.sender] = 0; // state update after external call
    }

    // Additional reentrancy vulnerability - external call before state update
    function claimRewards() external {
        uint256 rewardAmount = rewards[msg.sender];
        require(rewardAmount > 0, "No rewards to claim");
        
        // External call before state update - reentrancy vulnerability
        (bool success, ) = msg.sender.call{value: rewardAmount}("");
        require(success, "Transfer failed");
        
        rewards[msg.sender] = 0; // State update after external call
    }

    // Additional reentrancy vulnerability - callback during transfer
    function transferWithCallback(address to, uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        
        balances[msg.sender] -= amount;
        
        // External call that could trigger reentrancy
        (bool success, ) = to.call{value: amount}("");
        require(success, "Transfer failed");
        
        balances[to] += amount; // State update after external call
    }

    // Access control vulnerability - missing owner check
    function emergencyWithdraw() external {
        // Anyone can call this function - no access control
        uint256 contractBalance = address(this).balance;
        (bool sent, ) = msg.sender.call{value: contractBalance}("");
        require(sent);
    }

    // Access control vulnerability - weak authorization
    function updateRewards(address user, uint256 amount) external {
        // Only checks if caller has balance, not if they're authorized
        require(balances[msg.sender] > 0, "Must have balance");
        rewards[user] = amount; // Anyone with balance can update anyone's rewards
    }

    function getBalance() external view returns (uint256) {
        return balances[msg.sender];
    }

    function getRewards() external view returns (uint256) {
        return rewards[msg.sender];
    }
}
