// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;


import "../PublicAccessControl.sol";

/**
* @title DaoAccessControl
* @dev Access control contract for organization
* @custom:dev-run-script D:\IndividualProgramme\Blockchain\ProjectDAO\test\DaoAccessControl.test.js
*/
contract DaoAccessControl is PublicAccessControl{

    string public daoName = "";

    constructor(string memory Name) {
        _initialize();
        daoName = Name;
    }

    modifier allowPermission(bytes32 permission) {
        require(_check(permission, msg.sender), "DaoAccessControl: You have no permission to access this function.");
        _;
    }

    function createPermission(string memory permissionName) 
        public allowPermission(ACCESS_MANAGER) 
    {
        super._createPermission(keccak256(bytes(permissionName)));
    }

    function createPermissionByLevel(string memory permissionName, string memory permissionOriginal) 
        public allowPermission(ACCESS_MANAGER) 
    {
        super._createPermissionByLevel(keccak256(bytes(permissionName)), keccak256(bytes(permissionOriginal)));
    }

    function deletePermission(string memory permissionName) 
        public allowPermission(ACCESS_MANAGER)
    {
        super._deletePermission(keccak256(bytes(permissionName)));
    }

    function grantAccountPermission(string memory permissionName, address account) 
        public allowPermission(ACCESS_MANAGER) 
    {
        super._grantAccountPermission(keccak256(bytes(permissionName)), account);
    }

    function revokeAccountPermission(string memory permissionName, address account) 
        public allowPermission(ACCESS_MANAGER) 
    {
        super._revokeAccountPermission(keccak256(bytes(permissionName)), account);
    }

    function deleteAccount(address account) 
        public allowPermission(ACCESS_MANAGER) 
    {
        super._deleteAccount(account);
    }

    function transferAdmin(address account) 
        public allowPermission(ADMIN) 
    {
        super._transferAdmin(account);
    }

    //reload
    function inquiryAccountPermission(string memory permissionName, address account) 
        public view override allowPermission(STAFF) returns (bool) 
    {
        return super._inquiryAccountPermission(keccak256(bytes(permissionName)), account);
    }
    function inquiryAccountPermission(bytes32 permission, address account) 
        public view override allowPermission(STAFF) returns (bool) 
    {
        return super._inquiryAccountPermission(permission, account);
    }
    function inquiryAccountPermission(bytes32 projectPermission, bytes32 organizationPermission, address account) 
        public view override allowPermission(STAFF) returns (bool) 
    {
        projectPermission;
        return super._inquiryAccountPermission(organizationPermission, account);
    }

    function inquiryAllAccountsByPermission(string memory permissionName) 
        public view override allowPermission(STAFF) returns (address[] memory, bool[] memory) 
    {
        return super._inquiryAllAccountsByPermission(keccak256(bytes(permissionName)));
    }
    function inquiryAllAccountsByPermission(bytes32 permission) 
        public view override allowPermission(STAFF) returns (address[] memory, bool[] memory) 
    {
        return super._inquiryAllAccountsByPermission(permission);
    }

    function inquiryAllPermissionsByAccount(address account) 
        public view override allowPermission(STAFF) returns (bytes32[] memory, bool[] memory) 
    {
        return super._inquiryAllPermissionsByAccount(account);
    }

    function inquiryAllPermissions() 
        public view override allowPermission(STAFF) returns (bytes32[] memory, bool[] memory)
    {
        return super._inquiryAllPermissions();
    }

    function inquiryAdmin() 
        public view override allowPermission(STAFF) returns (address) 
    {
        return super._inquiryAdmin();
    }

    function inquiryDaoName()
        public view allowPermission(STAFF) returns (string memory) 
    {
        return daoName;
    }

    // function outputStorage() public view override returns (string memory) 
    // {
    //     return super._outputStorage();
    // }


}