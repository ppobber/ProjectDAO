// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;


import "../AccessControl.sol";
import "../IAccessControl.sol";


contract ProjectAccessControl is AccessControl{

    IAccessControl private daoAccessControl;

    string public adminName = "";
    string public adminEmail = "";

    constructor(address daoAccessControlAddress, string memory projectAdminName, string memory projectAdminEmail) {
        _initialize();
        daoAccessControl = IAccessControl(daoAccessControlAddress);
        adminName = projectAdminName;
        adminEmail = projectAdminEmail;
    }

    modifier allowPermission(bytes32 objectPermission, bytes32 organizationPermission) {
        require(
            _check(objectPermission, msg.sender) || daoAccessControl.inquiryAccountPermission(organizationPermission, msg.sender), 
            "AccessControl: You have no permission to access this function."
        );
        _;
    }

    function createPermission(bytes memory permissionName) 
        public allowPermission(ACCESS_MANAGER, ADMIN) 
    {
        super._createPermission(permissionName);
    }

    function createPermissionByLevel(bytes memory permissionName, bytes memory permissionAlready) 
        public allowPermission(ACCESS_MANAGER, ADMIN) 
    {
        super._createPermissionByLevel(permissionName, permissionAlready);
    }

    function deletePermission(bytes memory permissionName) 
        public allowPermission(ACCESS_MANAGER, ADMIN) 
    {
        super._deletePermission(permissionName);
    }

    function grantAccountPermission(bytes memory permissionName, address account) 
        public allowPermission(ACCESS_MANAGER, ADMIN) 
    {
        super._grantAccountPermission(permissionName, account);
    }

    function revokeAccountPermission(bytes memory permissionName, address account) 
        public allowPermission(ACCESS_MANAGER, ADMIN) 
    {
        super._revokeAccountPermission(permissionName, account);
    }

    function deleteAccount(address account) 
        public allowPermission(ACCESS_MANAGER, ADMIN) 
    {
        super._deleteAccount(account);
    }

    function transferAdmin(address account) 
        public allowPermission(ACCESS_MANAGER, ADMIN) 
    {
        super._transferAdmin(account);
    }

    function inquiryAccountPermission(bytes32 permission, address account) 
        public view allowPermission(STAFF, STAFF) returns (bool) 
    {
        return super._inquiryAccountPermission(permission, account);
    }

    function inquiryAllAccountsByPermission(bytes32 permission) 
        public view allowPermission(STAFF, STAFF) returns (address[] memory) 
    {
        return super._inquiryAllAccountsByPermission(permission);
    }

    function inquiryAllPermissionsByAccount(address account) 
        public view allowPermission(STAFF, STAFF) returns (bytes32[] memory) 
    {
        return super._inquiryAllPermissionsByAccount(account);
    }

    function inquiryAdmin() public view allowPermission(STAFF, STAFF) returns (address) {
        return super._inquiryAdmin();
    }

}