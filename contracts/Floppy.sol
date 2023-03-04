//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

contract Floppy {
    uint256 private cap = 50_000_000_000 * 10**uint256(18);
    address public owner;

    constructor() {
        // owner = msg.sender();
    }
}
