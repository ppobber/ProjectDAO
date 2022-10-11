// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;


import "../AccessControl.sol";


contract DaoAccessControl is AccessControl{

    constructor() {
        _initialize();
    }

    modifier allowPermission(bytes32 permission) {
        require(_check(permission, msg.sender), "AccessControl: You have no permission to access this function.");
        _;
    }

    function createPermission(string memory permissionName) 
        public allowPermission(ACCESS_MANAGER) 
    {
        super._createPermission(keccak256(bytes(permissionName)));
    }

    function createPermissionByLevel(string memory permissionName, string memory permissionAlready) 
        public allowPermission(ACCESS_MANAGER) 
    {
        super._createPermissionByLevel(keccak256(bytes(permissionName)), keccak256(bytes(permissionAlready)));
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
        public allowPermission(ACCESS_MANAGER) 
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

    function inquiryAllAccountsByPermission(string memory permissionName) 
        public view override allowPermission(STAFF) returns (address[] memory) 
    {
        return super._inquiryAllAccountsByPermission(keccak256(bytes(permissionName)));
    }
    function inquiryAllAccountsByPermission(bytes32 permission) 
        public view override allowPermission(STAFF) returns (address[] memory) 
    {
        return super._inquiryAllAccountsByPermission(permission);
    }

    function inquiryAllPermissionsByAccount(address account) 
        public view override allowPermission(STAFF) returns (bytes32[] memory) 
    {
        return super._inquiryAllPermissionsByAccount(account);
    }

    function inquiryAdmin() public view override allowPermission(STAFF) returns (address) 
    {
        return super._inquiryAdmin();
    }

    function outputStorage() public view override allowPermission(ADMIN)
    {
        return super._outputStorage();
    }


}