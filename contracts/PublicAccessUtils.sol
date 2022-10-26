// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./IPublicAccessControl.sol";

abstract contract PublicAccessUtils {

    bytes32 internal constant ADMIN = keccak256("ADMIN");
    // bytes32 internal constant MANAGER = keccak256("MANAGER");
    bytes32 internal constant STAFF = keccak256("STAFF");
    bytes32 internal constant MEMBER = keccak256("MEMBER");

    // bytes32 internal constant CONTRACT = keccak256("CONTRACT");

    mapping(bytes32 => bytes32) internal _functionPermission;

    IPublicAccessControl internal PublicAccessControl;

    function _initializeAccessControl(address AccessControlAddress) internal virtual {
        PublicAccessControl = IPublicAccessControl(AccessControlAddress);
    }

    function _getAdmin() internal virtual returns(address) {
        return PublicAccessControl.inquiryAdmin();
    }

    function _checkAccountPermission(bytes32 permission, address account) internal virtual returns(bool) {
        return PublicAccessControl.inquiryAccountPermission(permission, account);
    }

    //Organizational contracts should use this.
    modifier allowPermission(bytes32 permission) {
        require(PublicAccessControl.inquiryAccountPermission(
            permission, msg.sender), "AccessControlUtilities: You have no permission to access this function.");
        _;
    }

    //Project contracts should use this.
    modifier allowPermissions(bytes32 projectPermission, bytes32 organizationPermission) {
        require(PublicAccessControl.inquiryAccountPermission(
            projectPermission, 
            organizationPermission, 
            msg.sender
        ), "AccessControlUtilities: You have no permission to access this function.");
        _;
    }

    function _initializeFunctionPermission(bytes32 functionBytes, bytes32 permission) internal virtual {
        _functionPermission[functionBytes] = permission;
    }

    function _modifyFunctionPermission(bytes32 functionBytes, bytes32 permission) internal virtual {
        _functionPermission[functionBytes] = permission;
    }

    function _getFunctionPermission(bytes32 functionBytes) internal view virtual returns (bytes32) {
        return _functionPermission[functionBytes];
    }

    


}