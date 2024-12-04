// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "contracts/MedicalRecords.sol";

contract AccessControl is MedicalRecords {
    function checkAccess(address _patient, address _doctor) public view returns (bool) {
        address[] memory allowed = getDelegates(_patient);
        for (uint256 i = 0; i < allowed.length; i++) {
            if (allowed[i] == _doctor) {
                return true;
            }
        }
        return false;
    }
}
