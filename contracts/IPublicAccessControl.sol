// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/**
 * @dev This contract is an interface contract for access control.
 */
interface IPublicAccessControl{

    /**
     * @dev When a new permission is created, the event is published.
     */
    event PermissionCreated(bytes32 indexed permissionName, bytes32 indexed permissionOriginal, address indexed sender);

    /**
     * @dev When a permission is deleted, the event is published.
     */
    event PermissionDeleted(bytes32 indexed permissionName, address indexed sender);

    /**
     * @dev Publish the event when an account has been granted a permission.
     */
    event PermissionGranted(bytes32 indexed permissionName, address indexed account, address indexed sender);

    /**
     * @dev Publish this event when a permission of an account is revoked.
     */
    event PermissionRevoked(bytes32 indexed permissionName, address indexed account, address indexed sender);

    /**
     * @dev When an account is deleted, which is it loses all permissions at one time, and the event is published.
     */
    event AccountDeleted(address indexed account, address indexed sender);

    /**
     * @dev This event is published when the administrator is transferred to another account.
     */
    event AdminTransfered(address indexed newAdmin, address indexed previousAdmin);

    /**
     * @dev Query whether a specific account address has a specific permission. Returns true or false. 
     *
     * This function has three overloads. 
     * One for normal user, one for a contract within an organizational contract, and one for a contract within a project contract.
     */
    function inquiryAccountPermission(
        string memory permissionName, address account) external view returns (bool);

    function inquiryAccountPermission(
        bytes32 permission, address account) external view returns (bool);

    function inquiryAccountPermission(
        bytes32 projectPermission, bytes32 organizationPermission, address account) external view returns (bool);

    /**
     * @dev Query all accounts under a certain permission that use to have this permission. And returns a true or false list of whether they currently have the permission. 
     * 
     * This function has two overloads, one for normal user queries and one for contract call queries.
     */
    function inquiryAllAccountsByPermission(
        string memory permissionName) external view returns (address[] memory,  bool[] memory);

    function inquiryAllAccountsByPermission(
        bytes32 permission) external view returns (address[] memory,  bool[] memory);

    /**
     * @dev Query all permissions of an account.
     */
    function inquiryAllPermissionsByAccount(
        address account) external view returns (bytes32[] memory, bool[] memory);

    /**
     * @dev Query all permissions we have.
     */
    function inquiryAllPermissions() external view returns (bytes32[] memory, bool[] memory);

    /**
     * @dev Query the administrator address. In fact, a list of all historical administrators is returned. But only one is set to true.
     */
    function inquiryAdmin() external view returns (address);

}