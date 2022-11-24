// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../PublicAccessControl.sol";

/**
* @dev Organizational access control contract.
*
* as an organizational sign on the blockchain, is the first to be deployed. And any of the organizational contracts directly or indirectly require the address of that contract for successful deployment. The contract records the name of the organization. This contract also continues the overloading of the interface contract. Because it needs to be met and it needs to be easily accessible to both the user and the contract.
*/
contract DaoAccessControl is PublicAccessControl {

    string public daoName = "";

    constructor(string memory Name) {
        _initialize();
        daoName = Name;
    }

    /**
     * @dev A local modifier to check permission of access users.
     */
    modifier allowPermission(bytes32 permission) {
        require(_check(permission, msg.sender), "DaoAccessControl: You have no permission to access this function.");
        _;
    }

    /**
     * @dev See {PublicAccessControl-_createPermission}.
     */
    function createPermission(string memory permissionName) 
        public allowPermission(ACCESS_MANAGER) 
    {
        super._createPermission(keccak256(bytes(permissionName)));
    }

    /**
     * @dev See {PublicAccessControl-_createPermissionByLevel}.
     */
    function createPermissionByLevel(string memory permissionName, string memory permissionOriginal) 
        public allowPermission(ACCESS_MANAGER) 
    {
        super._createPermissionByLevel(keccak256(bytes(permissionName)), keccak256(bytes(permissionOriginal)));
    }

    /**
     * @dev See {PublicAccessControl-_deletePermission}.
     */
    function deletePermission(string memory permissionName) 
        public allowPermission(ACCESS_MANAGER)
    {
        super._deletePermission(keccak256(bytes(permissionName)));
    }

    /**
     * @dev See {PublicAccessControl-_grantAccountPermission}.
     */
    function grantAccountPermission(string memory permissionName, address account) 
        public allowPermission(ACCESS_MANAGER) 
    {
        super._grantAccountPermission(keccak256(bytes(permissionName)), account);
    }

    /**
     * @dev See {PublicAccessControl-_revokeAccountPermission}.
     */
    function revokeAccountPermission(string memory permissionName, address account) 
        public allowPermission(ACCESS_MANAGER) 
    {
        super._revokeAccountPermission(keccak256(bytes(permissionName)), account);
    }

    /**
     * @dev See {PublicAccessControl-_deleteAccount}.
     */
    function deleteAccount(address account) 
        public allowPermission(ACCESS_MANAGER) 
    {
        super._deleteAccount(account);
    }

    /**
     * @dev See {PublicAccessControl-_transferAdmin}.
     */
    function transferAdmin(address account) 
        public allowPermission(ADMIN) 
    {
        super._transferAdmin(account);
    }

    /**
     * @dev See {PublicAccessControl-_inquiryAccountPermission}.
     */
    function inquiryAccountPermission(string memory permissionName, address account) 
        public view override allowPermission(STAFF) returns (bool) 
    {
        return super._inquiryAccountPermission(keccak256(bytes(permissionName)), account);
    }

    /**
     * @dev Reload function. See {PublicAccessControl-_inquiryAccountPermission}.
     */
    function inquiryAccountPermission(bytes32 permission, address account) 
        public view override allowPermission(STAFF) returns (bool) 
    {
        return super._inquiryAccountPermission(permission, account);
    }

    /**
     * @dev Reload function. See {PublicAccessControl-_inquiryAccountPermission}.
     */
    function inquiryAccountPermission(bytes32 projectPermission, bytes32 organizationPermission, address account) 
        public view override allowPermission(STAFF) returns (bool) 
    {
        projectPermission;
        return super._inquiryAccountPermission(organizationPermission, account);
    }

    /**
     * @dev See {PublicAccessControl-_inquiryAllAccountsByPermission}.
     */
    function inquiryAllAccountsByPermission(string memory permissionName) 
        public view override allowPermission(STAFF) returns (address[] memory, bool[] memory) 
    {
        return super._inquiryAllAccountsByPermission(keccak256(bytes(permissionName)));
    }

    /**
     * @dev Reload function. See {PublicAccessControl-_inquiryAllAccountsByPermission}.
     */
    function inquiryAllAccountsByPermission(bytes32 permission) 
        public view override allowPermission(STAFF) returns (address[] memory, bool[] memory) 
    {
        return super._inquiryAllAccountsByPermission(permission);
    }

    /**
     * @dev See {PublicAccessControl-_inquiryAllPermissionsByAccount}.
     */
    function inquiryAllPermissionsByAccount(address account) 
        public view override allowPermission(STAFF) returns (bytes32[] memory, bool[] memory) 
    {
        return super._inquiryAllPermissionsByAccount(account);
    }

    /**
     * @dev See {PublicAccessControl-_inquiryAllPermissions}.
     */
    function inquiryAllPermissions() 
        public view override allowPermission(STAFF) returns (bytes32[] memory, bool[] memory)
    {
        return super._inquiryAllPermissions();
    }

    /**
     * @dev See {PublicAccessControl-_inquiryAdmin}.
     */
    function inquiryAdmin() 
        public view override allowPermission(STAFF) returns (address) 
    {
        return super._inquiryAdmin();
    }

    /**
     * @dev Inquiry the organizational name.
     */
    function inquiryDaoName()
        public view allowPermission(STAFF) returns (string memory) 
    {
        return daoName;
    }

}