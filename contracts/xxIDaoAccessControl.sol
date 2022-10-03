// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface IDaoAccessControl{

    event PermissionCreated(bytes indexed permissionName, address indexed sender);

    event PermissionDeleted(bytes indexed permissionName, address indexed sender);

    event PermissionGranted(bytes indexed permissionName, address indexed account, address indexed sender);

    event PermissionRevoked(bytes indexed permissionName, address indexed account, address indexed sender);

    event AccountDeleted(address indexed account, address indexed sender);

    event AdminTransfered(address indexed newAdmin, address indexed previousAdmin);

    

    function createPermission(bytes memory permissionName) external;

    function createPermissionByLevel(bytes memory permissionName, bytes memory permissionAlready) external;

    function deletePermission(bytes memory permissionName) external;

    function grantAccountPermission(bytes memory permissionName, address account) external;

    function revokeAccountPermission(bytes memory permissionName, address account) external;

    function deleteAccount(address account) external;

    function transferAdmin(address account) external;

    function inquiryAccountPermission(bytes32 permission, address account) external view returns (bool);

    function inquiryAllAccountsByPermission(bytes32 permission) external view returns (address[] memory);

    function inquiryAllPermissionsByAccount(address account) external view returns (bytes32[] memory);    


}