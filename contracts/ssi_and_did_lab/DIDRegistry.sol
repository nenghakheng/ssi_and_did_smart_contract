// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DIDRegistry {
    // Enum representing user's role
    enum Roles {
        Admin,
        Doctor,
        Patient
    }

    struct DID {
        string identifier;
        address owner;
        string role;
    }
    // Private: Address to each user is unique. This link did to eth address
    mapping(address => DID) private dids;

    event DIDRegistered(address indexed owner, string identifier);
    event RoleAssigned(address indexed owner, string role);
    event DIDUpdated(string oldDID, string newDID);
    event RoleUpdated(string oldRole, string newRole);

    function compareStrings(string memory _a, string memory _b) public pure returns(bool) {
        return keccak256(bytes(_a)) == keccak256(bytes(_b)); // Convert the string into a SHA-256 hash and compare it.
    }

    function createDID(string memory _identifier) public {
        require( bytes(_identifier).length > 0, "DID already exists for this address.");
        require(dids[msg.sender].owner == address(0), "DID already exists for this address.");

        dids[msg.sender] = DID(_identifier, msg.sender, "");

        emit DIDRegistered(msg.sender, _identifier);
    }

    function updateDID(string memory _newDID) public {
        string memory _oldDID = getDID(); // Get old id using the getID method.

        require(dids[msg.sender].owner != address(0), "No DID found for this address");
        require(bytes(_newDID).length > 0, "New DID cannot be empty.");
        require(
        compareStrings(dids[msg.sender].identifier, _oldDID),
        "DID does not match."
        );
        require(
        !compareStrings(dids[msg.sender].identifier, _newDID),
        "New DID is still the same."
        );

        dids[msg.sender].identifier = _newDID;

        emit DIDUpdated(_oldDID, _newDID);
    }

    function getDID() public view returns(string memory) {
        require(dids[msg.sender].owner != address(0), "No DID found for this address");
        return dids[msg.sender].identifier;
    }

    // Role Management
    Roles public roles;

    // Returns uint
    // Pending  - 0
    // Shipped  - 1
    // Accepted - 2
    // Rejected - 3
    // Canceled - 4
    function getAllRoles() public view returns (Roles) {
        return roles;
    }

    function assignRole(string memory _role) public {
        require(dids[msg.sender].owner != address(0), "No DID found for this address");
        require(bytes(_role).length > 0, "Role cannot be empty.");
        // require(
        //     compareStrings(dids[msg.sender].role, _role),
        //     "Role already assigned"
        // );

        dids[msg.sender].role = _role;

        emit RoleAssigned(msg.sender, _role);
    }

    function updateRole(string memory _newRole) public {
        string memory _oldRole = getRole();

        require(dids[msg.sender].owner != address(0), "No DID found for this address");
        require(bytes(_newRole).length > 0, "Role cannot be empty.");
        require(
            !compareStrings(_oldRole, _newRole),
            "New Role should be different from the old Role."
        );

        dids[msg.sender].role = _newRole;

        emit RoleUpdated(_oldRole, _newRole);
    }

    function getRole() public view returns(string memory) {
        require(dids[msg.sender].owner != address(0), "No DID found for this address");
        return dids[msg.sender].role;
    }

    // function getAllRoles() public view returns(ROLES) {
    //     return choices;
    // }
}