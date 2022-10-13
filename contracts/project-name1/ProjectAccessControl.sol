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

    function createPermission(string memory permissionName) 
        public allowPermission(ACCESS_MANAGER, ADMIN) 
    {
        super._createPermission(keccak256(bytes(permissionName)));
    }

    function createPermissionByLevel(string memory permissionName, string memory permissionOriginal) 
        public allowPermission(ACCESS_MANAGER, ADMIN) 
    {
        super._createPermissionByLevel(keccak256(bytes(permissionName)), keccak256(bytes(permissionOriginal)));
    }

    function deletePermission(string memory permissionName) 
        public allowPermission(ACCESS_MANAGER, ADMIN) 
    {
        super._deletePermission(keccak256(bytes(permissionName)));
    }

    function grantAccountPermission(string memory permissionName, address account) 
        public allowPermission(ACCESS_MANAGER, ADMIN) 
    {
        super._grantAccountPermission(keccak256(bytes(permissionName)), account);
    }

    function revokeAccountPermission(string memory permissionName, address account) 
        public allowPermission(ACCESS_MANAGER, ADMIN) 
    {
        super._revokeAccountPermission(keccak256(bytes(permissionName)), account);
    }

    function deleteAccount(address account) 
        public allowPermission(ACCESS_MANAGER, ADMIN) 
    {
        super._deleteAccount(account);
    }

    function transferAdmin(address account) 
        public allowPermission(ADMIN, ADMIN) 
    {
        super._transferAdmin(account);
    }

    function inquiryAccountPermission(string memory permissionName, address account) 
        public view override allowPermission(STAFF, STAFF) returns (bool) 
    {
        return super._inquiryAccountPermission(keccak256(bytes(permissionName)), account);
    }
    function inquiryAccountPermission(bytes32 permission, address account) 
        public view override allowPermission(STAFF, STAFF) returns (bool) 
    {
        return super._inquiryAccountPermission(permission, account);
    }

    function inquiryAllAccountsByPermission(string memory permissionName) 
        public view override allowPermission(STAFF, STAFF) returns (address[] memory, bool[] memory) 
    {
        return super._inquiryAllAccountsByPermission(keccak256(bytes(permissionName)));
    }
    function inquiryAllAccountsByPermission(bytes32 permission) 
        public view override allowPermission(STAFF, STAFF) returns (address[] memory, bool[] memory) 
    {
        return super._inquiryAllAccountsByPermission(permission);
    }

    function inquiryAllPermissionsByAccount(address account) 
        public view override allowPermission(STAFF, STAFF) returns (bytes32[] memory, bool[] memory) 
    {
        return super._inquiryAllPermissionsByAccount(account);
    }

    function inquiryAllPermissions() 
        public view override allowPermission(STAFF, STAFF) returns (bytes32[] memory, bool[] memory)
    {
        return super._inquiryAllPermissions();
    }

    function inquiryAdmin() 
        public view override allowPermission(STAFF, STAFF) returns (address) 
    {
        return super._inquiryAdmin();
    }

}