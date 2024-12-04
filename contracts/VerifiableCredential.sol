// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VerifiableCredential {
    struct VerifiableCredential {
        string credentialID;
        string issuer;
        string issuedTo;
        string metadata;
        bool isValid;
    }

    mapping(string => VerifiableCredential) private credentials;

    event CredentialIssued(string indexed credentialID, string issuer, string issuedTo);
    event CredentialRevoked(string indexed credentialID);

    function issueCredential(
        string memory _credentialID,
        string memory _issuer,
        string memory _issuedTo,
        string memory _metadata
    ) public {
        require(bytes(_credentialID).length > 0, "Credential ID cannot be empty.");
        require(credentials[_credentialID].isValid == false, "Credential already exists.");

        credentials[_credentialID] = VerifiableCredential(
            _credentialID,
            _issuer,
            _issuedTo,
            _metadata,
            true
        );

        emit CredentialIssued(_credentialID, _issuer, _issuedTo);
    }

    function revokeCredential(string memory _credentialID) public {
        require(credentials[_credentialID].isValid == true, "Credential does not exist or is invalid.");

        credentials[_credentialID].isValid = false;

        emit CredentialRevoked(_credentialID);
    }

    function getCredential(string memory _credentialID) public view returns (VerifiableCredential memory) {
        require(credentials[_credentialID].isValid == true, "Credential is not valid.");
        return credentials[_credentialID];
    }
}
