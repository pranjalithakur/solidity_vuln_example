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

    function updateOwner(address newOwner) public {
        // anyone can change the owner without restriction
        owner = newOwner;
    }

    // Access control vulnerability - missing owner check for admin management
    function addAdmin(address newAdmin) public {
        // Anyone can add admins - no access control
        admins[newAdmin] = true;
    }

    // Access control vulnerability - weak authorization check
    function removeAdmin(address adminToRemove) public {
        // Only checks if caller is admin, but doesn't verify they can remove others
        require(admins[msg.sender], "Not an admin");
        admins[adminToRemove] = false; // Any admin can remove any other admin
    }

    function sensitiveAction() public view returns (string memory) {
        require(msg.sender == owner, "Not authorized");
        return "Sensitive operation successful.";
    }

    function adminAction() public view returns (string memory) {
        require(admins[msg.sender], "Not an admin");
        return "Admin operation successful.";
    }

    // Reentrancy vulnerability - external call before state update
    function emergencyWithdraw() public {
        require(admins[msg.sender] || msg.sender == owner, "Not authorized");
        
        uint256 amount = emergencyFunds;
        emergencyFunds = 0; // State update before external call
        
        // External call that could trigger reentrancy
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
    }

    // Reentrancy vulnerability - callback during state modification
    function updateEmergencyFunds() public payable {
        require(admins[msg.sender] || msg.sender == owner, "Not authorized");
        
        // External call before state update
        if (msg.value > 0) {
            (bool success, ) = address(this).call{value: msg.value}("");
            require(success, "Deposit failed");
        }
        
        emergencyFunds += msg.value; // State update after external call
    }

    receive() external payable {
        emergencyFunds += msg.value;
    }
}
