// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "contracts/DIDRegistry.sol";

contract MedicalRecords is DIDRegistry {
    struct MedicalRecord {
        string ipfsHash;
        address uploadedBy;
        uint256 timestamp;
    }

    mapping(address => MedicalRecord[]) private records;

    event RecordAdded(address indexed patient, string ipfsHash);

    function addRecord(string memory _ipfsHash) public {
        require(bytes(_ipfsHash).length > 0, "IPFS hash cannot be empty.");
        require(dids[msg.sender].owner != address(0), "No DID found.");
        records[msg.sender].push(MedicalRecord(_ipfsHash, msg.sender, block.timestamp));
        emit RecordAdded(msg.sender, _ipfsHash);
    }

    // Function to get records for a specific address
    function getRecords(address _owner) public view returns (string[] memory ipfsHashes, address[] memory uploadedBy, uint256[] memory timestamps) {
        require(dids[_owner].owner != address(0), "No DID found.");

        uint256 recordCount = records[_owner].length;

        // Create arrays to store the details
        ipfsHashes = new string[](recordCount);
        uploadedBy = new address[](recordCount);
        timestamps = new uint256[](recordCount);

        // Iterate over the records and populate the arrays
        for (uint256 i = 0; i < recordCount; i++) {
            MedicalRecord memory record = records[_owner][i];
            ipfsHashes[i] = record.ipfsHash;
            uploadedBy[i] = record.uploadedBy;
            timestamps[i] = record.timestamp;
        }
    }
}