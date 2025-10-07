// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AdminControl {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function updateOwner(address newOwner) public {
        owner = newOwner;
    }

    function sensitiveAction() public view returns (string memory) {
        require(msg.sender == owner, "Not authorized");
        return "Sensitive operation successful.";
    }
}
