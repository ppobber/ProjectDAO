// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;


import "../PublicAccessControl.sol";
import "../IPublicAccessControl.sol";


contract ProjectAccessControl is PublicAccessControl{

    IPublicAccessControl private daoAccessControl;

    string public adminName = "";
    string public adminEmail = "";

    constructor(address daoAccessControlAddress, string memory projectAdminName, string memory projectAdminEmail) {
        _initialize();
        daoAccessControl = IPublicAccessControl(daoAccessControlAddress);
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

    //should update the administrator information
    function transferAdmin(address account, string memory newAdminName, string memory newAdminEmail) 
        public allowPermission(ADMIN, ADMIN) 
    {
        super._transferAdmin(account);
        adminName = newAdminName;
        adminEmail = newAdminEmail;
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
    function inquiryAccountPermission(bytes32 projectPermission, bytes32 organizationPermission, address account) 
        public view override allowPermission(STAFF, STAFF) returns (bool) 
    {
        if (super._inquiryAccountPermission(projectPermission, account)) {
            return true;
        } else {
            return daoAccessControl.inquiryAccountPermission(organizationPermission, account);
        }
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

    function inquiryAdminInformation()
        public view allowPermission(STAFF, STAFF) returns (string memory, string memory) 
    {
        return (adminName, adminEmail);
    }

}