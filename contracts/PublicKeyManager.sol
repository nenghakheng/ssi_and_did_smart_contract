// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PublicKeyManager {
    mapping(address => string) private publicKeys;

    event PublicKeyAdded(address indexed owner, string publicKey);

    function addPublicKey(string memory _publicKey) public {
        require(bytes(_publicKey).length > 0, "Public key cannot be empty.");
        require(bytes(publicKeys[msg.sender]).length == 0, "Public key already exists.");

        publicKeys[msg.sender] = _publicKey;

        emit PublicKeyAdded(msg.sender, _publicKey);
    }

    function getPublicKey(address _owner) public view returns (string memory) {
        require(bytes(publicKeys[_owner]).length > 0, "No public key found for this address.");
        return publicKeys[_owner];
    }
}
