// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../PublicAccessControl.sol";
import "../IPublicAccessControl.sol";

/**
 * @dev The project access control contract is almost identical to the organization, inherits directly from the public. Based on this, the project access control contract needs to record its own project name. The name and email of the administrator of the project are also recorded.
 *
 * In order to reflect that the project belongs to an organization. The project access control contract must contain its own instance of the organization access control contract. At the same time, the biggest difference from the organization contract is that when using all the access control modifiers, not only the access control contract should be queried, but also the query function in the organization access control contract should be called to get the corresponding permission. So, we also need to remember to grant access to the project access control contract address in the organizational access control contract in advance.
 * 
 * In general, if a function allows access for project staff, it can also allow access for organization staff. If a function allows access to the project manager, it will generally only allow access to the organization administrator.
 */
contract ProjectAccessControl is PublicAccessControl{

    IPublicAccessControl private daoAccessControl;

    string public Name = "";
    string public adminName = "";
    string public adminEmail = "";

    constructor(
        address daoAccessControlAddress, 
        string memory projectName,
        string memory projectAdminName, 
        string memory projectAdminEmail) 
    {
        _initialize();
        daoAccessControl = IPublicAccessControl(daoAccessControlAddress);
        Name = projectName;
        adminName = projectAdminName;
        adminEmail = projectAdminEmail;
    }

    /**
     * @dev A local modifier to check permission of access users.
     */
    modifier allowPermissions(bytes32 objectPermission, bytes32 organizationPermission) {
        //short circuit characteristic
        require(
            _check(objectPermission, msg.sender) || daoAccessControl.inquiryAccountPermission(organizationPermission, msg.sender), 
            "ProjectAccessControl: You have no permission to access this function."
        );
        _;
    }

    /**
     * @dev See {PublicAccessControl-_createPermission}.
     */
    function createPermission(string memory permissionName) 
        public allowPermissions(ACCESS_MANAGER, ADMIN) 
    {
        super._createPermission(keccak256(bytes(permissionName)));
    }

    /**
     * @dev See {PublicAccessControl-_createPermissionByLevel}.
     */
    function createPermissionByLevel(string memory permissionName, string memory permissionOriginal) 
        public allowPermissions(ACCESS_MANAGER, ADMIN) 
    {
        super._createPermissionByLevel(keccak256(bytes(permissionName)), keccak256(bytes(permissionOriginal)));
    }

    /**
     * @dev See {PublicAccessControl-_deletePermission}.
     */
    function deletePermission(string memory permissionName) 
        public allowPermissions(ACCESS_MANAGER, ADMIN) 
    {
        super._deletePermission(keccak256(bytes(permissionName)));
    }

    /**
     * @dev See {PublicAccessControl-_grantAccountPermission}.
     */
    function grantAccountPermission(string memory permissionName, address account) 
        public allowPermissions(ACCESS_MANAGER, ADMIN) 
    {
        super._grantAccountPermission(keccak256(bytes(permissionName)), account);
    }

    /**
     * @dev See {PublicAccessControl-_revokeAccountPermission}.
     */
    function revokeAccountPermission(string memory permissionName, address account) 
        public allowPermissions(ACCESS_MANAGER, ADMIN) 
    {
        super._revokeAccountPermission(keccak256(bytes(permissionName)), account);
    }

    /**
     * @dev See {PublicAccessControl-_deleteAccount}.
     */
    function deleteAccount(address account) 
        public allowPermissions(ACCESS_MANAGER, ADMIN) 
    {
        super._deleteAccount(account);
    }

    /**
     * @dev See {PublicAccessControl-_transferAdmin}.
     *
     * Should update the administrator information.
     */
    function transferAdmin(address account, string memory newAdminName, string memory newAdminEmail) 
        public allowPermissions(ADMIN, ADMIN) 
    {
        super._transferAdmin(account);
        adminName = newAdminName;
        adminEmail = newAdminEmail;
    }

    /**
     * @dev See {PublicAccessControl-_inquiryAccountPermission}.
     */
    function inquiryAccountPermission(string memory permissionName, address account) 
        public view override allowPermissions(STAFF, STAFF) returns (bool) 
    {
        return super._inquiryAccountPermission(keccak256(bytes(permissionName)), account);
    }

    /**
     * @dev Reload function. See {PublicAccessControl-_inquiryAccountPermission}.
     */
    function inquiryAccountPermission(bytes32 permission, address account) 
        public view override allowPermissions(STAFF, STAFF) returns (bool) 
    {
        return super._inquiryAccountPermission(permission, account);
    }

    /**
     * @dev Reload function. See {PublicAccessControl-_inquiryAccountPermission}.
     */
    function inquiryAccountPermission(bytes32 projectPermission, bytes32 organizationPermission, address account) 
        public view override allowPermissions(STAFF, STAFF) returns (bool) 
    {
        if (super._inquiryAccountPermission(projectPermission, account)) {
            return true;
        } else {
            return daoAccessControl.inquiryAccountPermission(organizationPermission, account);
        }
    }

    /**
     * @dev See {PublicAccessControl-_inquiryAllAccountsByPermission}.
     */
    function inquiryAllAccountsByPermission(string memory permissionName) 
        public view override allowPermissions(STAFF, STAFF) returns (address[] memory, bool[] memory) 
    {
        return super._inquiryAllAccountsByPermission(keccak256(bytes(permissionName)));
    }

    /**
     * @dev Reload function. See {PublicAccessControl-_inquiryAllAccountsByPermission}.
     */
    function inquiryAllAccountsByPermission(bytes32 permission) 
        public view override allowPermissions(STAFF, STAFF) returns (address[] memory, bool[] memory) 
    {
        return super._inquiryAllAccountsByPermission(permission);
    }

    /**
     * @dev See {PublicAccessControl-_inquiryAllPermissionsByAccount}.
     */
    function inquiryAllPermissionsByAccount(address account) 
        public view override allowPermissions(STAFF, STAFF) returns (bytes32[] memory, bool[] memory) 
    {
        return super._inquiryAllPermissionsByAccount(account);
    }

    /**
     * @dev See {PublicAccessControl-_inquiryAllPermissions}.
     */
    function inquiryAllPermissions() 
        public view override allowPermissions(STAFF, STAFF) returns (bytes32[] memory, bool[] memory)
    {
        return super._inquiryAllPermissions();
    }

    /**
     * @dev See {PublicAccessControl-_inquiryAdmin}.
     */
    function inquiryAdmin() 
        public view override allowPermissions(STAFF, STAFF) returns (address) 
    {
        return super._inquiryAdmin();
    }

    /**
     * @dev This function retrieves information about the project. Include the project administrator name and email.
     */
    function inquiryProjectInformation()
        public view allowPermissions(STAFF, STAFF) 
        returns (string memory, string memory, string memory) 
    {
        return (Name, adminName, adminEmail);
    }

}