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

    function createPermission(bytes memory permissionName) 
        public allowPermission(ACCESS_MANAGER) 
    {
        super._createPermission(permissionName);
    }

    function createPermissionByLevel(bytes memory permissionName, bytes memory permissionAlready) 
        public allowPermission(ACCESS_MANAGER) 
    {
        super._createPermissionByLevel(permissionName, permissionAlready);
    }

    function deletePermission(bytes memory permissionName) 
        public allowPermission(ACCESS_MANAGER) 
    {
        super._deletePermission(permissionName);
    }

    function grantAccountPermission(bytes memory permissionName, address account) 
        public allowPermission(ACCESS_MANAGER) 
    {
        super._grantAccountPermission(permissionName, account);
    }

    function revokeAccountPermission(bytes memory permissionName, address account) 
        public allowPermission(ACCESS_MANAGER) 
    {
        super._revokeAccountPermission(permissionName, account);
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

    function inquiryAccountPermission(bytes32 permission, address account) 
        public view allowPermission(STAFF) returns (bool) 
    {
        return super._inquiryAccountPermission(permission, account);
    }

    function inquiryAllAccountsByPermission(bytes32 permission) 
        public view allowPermission(STAFF) returns (address[] memory) 
    {
        return super._inquiryAllAccountsByPermission(permission);
    }

    function inquiryAllPermissionsByAccount(address account) 
        public view allowPermission(STAFF) returns (bytes32[] memory) 
    {
        return super._inquiryAllPermissionsByAccount(account);
    }

    function inquiryAdmin() public view allowPermission(STAFF) returns (address) 
    {
        return super._inquiryAdmin();
    }


}