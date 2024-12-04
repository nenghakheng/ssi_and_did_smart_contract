// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DIDRegistry {
    // Enum for roles
    enum Roles { Admin, Doctor, Patient }

    struct DID {
        string identifier;
        address owner;
        Roles role;
    }

    mapping(address => DID) internal dids;
    mapping(address => address[]) private delegates;

    event DIDRegistered(address indexed owner, string identifier);
    event RoleAssigned(address indexed owner, Roles role);  // Updated event to use enum
    event AccessGranted(address indexed patient, address indexed doctor);
    event AccessRevoked(address indexed patient, address indexed doctor);

    function createDID(string memory _identifier) public {
        require(bytes(_identifier).length > 0, "Identifier cannot be empty.");
        require(dids[msg.sender].owner == address(0), "DID already exists.");
        dids[msg.sender] = DID(_identifier, msg.sender, Roles.Patient);  // Default to "Patient"
        emit DIDRegistered(msg.sender, _identifier);
    }

    function assignRole(Roles _role) public {
        require(dids[msg.sender].owner != address(0), "No DID found.");
        dids[msg.sender].role = _role;
        emit RoleAssigned(msg.sender, _role);
    }

    function updateRole(Roles _newRole) public {
        Roles _oldRole = dids[msg.sender].role;

        require(dids[msg.sender].owner != address(0), "No DID found.");
        require(_newRole != _oldRole, "New Role must be different from the old Role.");

        dids[msg.sender].role = _newRole;
        emit RoleAssigned(msg.sender, _newRole);  // Event updated to use enum
    }

    function getRole() public view returns (Roles) {
        require(dids[msg.sender].owner != address(0), "No DID found.");
        return dids[msg.sender].role;
    }

    function getRoleString() public view returns (string memory) {
        // Helper function to convert role enum to string
        require(dids[msg.sender].owner != address(0), "No DID found.");
        if (dids[msg.sender].role == Roles.Admin) return "Admin";
        if (dids[msg.sender].role == Roles.Doctor) return "Doctor";
        if (dids[msg.sender].role == Roles.Patient) return "Patient";
        return "";
    }

    function grantAccess(address _doctor) public {
        require(dids[msg.sender].owner != address(0), "No DID found.");
        require(dids[_doctor].owner != address(0), "Doctor must have a DID.");
        delegates[msg.sender].push(_doctor);
        emit AccessGranted(msg.sender, _doctor);
    }

    function revokeAccess(address _doctor) public {
        require(dids[msg.sender].owner != address(0), "No DID found.");
        require(dids[_doctor].owner != address(0), "Doctor must have a DID.");

        for (uint256 i = 0; i < delegates[msg.sender].length; i++) {
            if (delegates[msg.sender][i] == _doctor) {
                delegates[msg.sender][i] = delegates[msg.sender][delegates[msg.sender].length - 1];
                delegates[msg.sender].pop();
                emit AccessRevoked(msg.sender, _doctor);
                return;
            }
        }
    }

    function getDelegates(address _owner) public view returns (address[] memory) {
        return delegates[_owner];
    }
}
