// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface IPublicAccessControl{

    event PermissionCreated(bytes32 indexed permissionName, bytes32 indexed permissionOriginal, address indexed sender);

    event PermissionDeleted(bytes32 indexed permissionName, address indexed sender);

    event PermissionGranted(bytes32 indexed permissionName, address indexed account, address indexed sender);

    event PermissionRevoked(bytes32 indexed permissionName, address indexed account, address indexed sender);

    event AccountDeleted(address indexed account, address indexed sender);

    event AdminTransfered(address indexed newAdmin, address indexed previousAdmin);

    // event StorageOutput(string indexed storageJson);

    
    // function _createPermission(bytes32 permission) external;
    // function _createPermissionByLevel(bytes32 permission, bytes32 permissionA) external;
    // function _deletePermission(bytes32 permission) external;
    // function _grantAccountPermission(bytes32 permission, address account) external;
    // function _revokeAccountPermission(bytes32 permission, address account) external;
    // function _deleteAccount(address account) external;
    // function _transferAdmin(address account) external;

    function inquiryAccountPermission(
        string memory permissionName, address account) external view returns (bool);
    function inquiryAccountPermission(
        bytes32 permission, address account) external view returns (bool);
    function inquiryAccountPermission(
        bytes32 projectPermission, bytes32 organizationPermission, address account) external view returns (bool);

    function inquiryAllAccountsByPermission(
        string memory permissionName) external view returns (address[] memory,  bool[] memory);
    function inquiryAllAccountsByPermission(
        bytes32 permission) external view returns (address[] memory,  bool[] memory);

    function inquiryAllPermissionsByAccount(
        address account) external view returns (bytes32[] memory, bool[] memory);

    function inquiryAllPermissions() external view returns (bytes32[] memory, bool[] memory);

    function inquiryAdmin() external view returns (address);

    // function outputStorage() external view returns (string memory);

}