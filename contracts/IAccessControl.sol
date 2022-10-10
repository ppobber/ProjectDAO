// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface IAccessControl{

    event PermissionCreated(bytes32 indexed permissionName, address indexed sender);

    event PermissionDeleted(bytes32 indexed permissionName, address indexed sender);

    event PermissionGranted(bytes32 indexed permissionName, address indexed account, address indexed sender);

    event PermissionRevoked(bytes32 indexed permissionName, address indexed account, address indexed sender);

    event AccountDeleted(address indexed account, address indexed sender);

    event AdminTransfered(address indexed newAdmin, address indexed previousAdmin);

    
    // function _createPermission(bytes32 permission) external;
    // function _createPermissionByLevel(bytes32 permission, bytes32 permissionA) external;
    // function _deletePermission(bytes32 permission) external;
    // function _grantAccountPermission(bytes32 permission, address account) external;
    // function _revokeAccountPermission(bytes32 permission, address account) external;
    // function _deleteAccount(address account) external;
    // function _transferAdmin(address account) external;

    function inquiryAccountPermission(string memory permissionName, address account) external view returns (bool);
    function inquiryAccountPermission(bytes32 permission, address account) external view returns (bool);

    function inquiryAllAccountsByPermission(string memory permissionName) external view returns (address[] memory);
    function inquiryAllAccountsByPermission(bytes32 permission) external view returns (address[] memory);

    function inquiryAllPermissionsByAccount(address account) external view returns (bytes32[] memory);

    function inquiryAdmin() external view returns (address);

}