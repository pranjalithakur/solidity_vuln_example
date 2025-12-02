// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AdminControl {
    address public owner;
    mapping(address => bool) public admins;
    uint256 public emergencyFunds;

    constructor() {
        owner = msg.sender;
        admins[msg.sender] = true;
    }

// new comment

    function updateOwner(address newOwner) public {
        owner = newOwner;
    }

    function addAdmin(address newAdmin) public {
        admins[newAdmin] = true;
    }

    function removeAdmin(address adminToRemove) public {
        require(admins[msg.sender], "Not an admin");
        admins[adminToRemove] = false; 
    }

    function sensitiveAction() public view returns (string memory) {
        require(msg.sender == owner, "Not authorized");
        return "Sensitive operation successful.";
    }

    function adminAction() public view returns (string memory) {
        require(admins[msg.sender], "Not an admin");
        return "Admin operation successful.";
    }

    function emergencyWithdraw() public {
        require(admins[msg.sender] || msg.sender == owner, "Not authorized");
        
        uint256 amount = emergencyFunds;
        emergencyFunds = 0; 
        
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
    }

    function updateEmergencyFunds() public payable {
        require(admins[msg.sender] || msg.sender == owner, "Not authorized");
        
        if (msg.value > 0) {
            (bool success, ) = address(this).call{value: msg.value}("");
            require(success, "Deposit failed");
        }
        
        emergencyFunds += msg.value; 
    }

    receive() external payable {
        emergencyFunds += msg.value;
    }
}
