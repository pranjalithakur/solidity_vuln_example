// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EtherBank {
    mapping(address => uint256) public balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() external {
        uint256 amount = balances[msg.sender];
        (bool sent, ) = msg.sender.call{value: amount}(""); // call before state update
        require(sent);
        balances[msg.sender] = 0; // state update after external call
    }

    function getBalance() external view returns (uint256) {
        return balances[msg.sender];
    }
}
