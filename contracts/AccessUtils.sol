// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./IAccessControl.sol";

abstract contract AccessUtils {

    bytes32 internal constant ADMIN = keccak256("ADMIN");
    bytes32 internal constant MANAGER = keccak256("MANAGER");
    bytes32 internal constant STAFF = keccak256("STAFF");
    bytes32 internal constant MEMBER = keccak256("MEMBER");

    bytes32 internal constant CONTRACT = keccak256("CONTRACT");

    bytes32 internal constant TOKEN_MANAGER = keccak256("TOKEN_MANAGER");
    bytes32 internal constant ACCESS_MANAGER = keccak256("ACCESS_MANAGER");



    IAccessControl internal AccessControl;

    // constructor(address AccessControlAddress) {
    //     AccessControl = IAccessControl(AccessControlAddress);
    // }

    function initializeAccessControl(address AccessControlAddress) internal virtual {
        AccessControl = IAccessControl(AccessControlAddress);
    }

    function getAdmin() internal virtual returns(address) {
        return AccessControl.inquiryAdmin();
    }

    modifier allowPermission(bytes32 permission) {
        require(AccessControl.inquiryAccountPermission(permission, msg.sender));
        _;
    }


}