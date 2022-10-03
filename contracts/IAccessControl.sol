// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface IAccessControl{

    event PermissionCreated(bytes indexed permissionName, address indexed sender);

    event PermissionDeleted(bytes indexed permissionName, address indexed sender);

    event PermissionGranted(bytes indexed permissionName, address indexed account, address indexed sender);

    event PermissionRevoked(bytes indexed permissionName, address indexed account, address indexed sender);

    event AccountDeleted(address indexed account, address indexed sender);

    event AdminTransfered(address indexed newAdmin, address indexed previousAdmin);

    
    // function _createPermission(bytes memory permissionName) external;
    // function _createPermissionByLevel(bytes memory permissionName, bytes memory permissionAlready) external;
    // function _deletePermission(bytes memory permissionName) external;
    // function _grantAccountPermission(bytes memory permissionName, address account) external;
    // function _revokeAccountPermission(bytes memory permissionName, address account) external;
    // function _deleteAccount(address account) external;
    // function _transferAdmin(address account) external;

    function inquiryAccountPermission(bytes32 permission, address account) external view returns (bool);

    function inquiryAllPermissionsByAccount(address account) external view returns (bytes32[] memory);

    function inquiryAllAccountsByPermission(bytes32 permission) external view returns (address[] memory);

    function inquiryAdmin() external view returns (address);

}