// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./IPublicAccessControl.sol";

/**
 * This contract is designed to make it easier for other contracts to use access control. 
 *
 * So the process of instantiating and invoking the access control contract is integrated into a whole module. Other contracts just simply inherit from this contract to use access control directly. 
 *
 * We also added a small feature to the contract to deal with a more complex reality. It has an array of all function permissions that can be modified at any time. To use this functionality, simply call the contents of the table in the derived contract where access control is required. Changing different functional permissions at any time transfers the power to modify permissions to the contract manager, making the organization run more smoothly under certain circumstances.
 * 
 * @notice Before the contract can be used, it must also be recorded in the access control contract, which is the permission to grant the address of the contract to the staff. So the contract can access the content successfully.
 *
 */
abstract contract PublicAccessUtils {

    bytes32 internal constant ADMIN = keccak256("ADMIN");
    bytes32 internal constant STAFF = keccak256("STAFF");
    bytes32 internal constant MEMBER = keccak256("MEMBER");

    mapping(bytes32 => bytes32) internal _functionPermission;

    IPublicAccessControl internal PublicAccessControl;

    /**
     * @dev The derived contract calls this function in the initialization process to obtain an instance of the access control contract. 
     * From this instance, we can perform a series of query operations.
     */
    function _initializeAccessControl(address AccessControlAddress) internal virtual {
        PublicAccessControl = IPublicAccessControl(AccessControlAddress);
    }

    /**
     * @dev Query the administrator address of the organization or project.
     */
    function _getAdmin() internal virtual returns(address) {
        return PublicAccessControl.inquiryAdmin();
    }

    /**
     * @dev Query whether an account has a specific permission.
     */
    function _checkAccountPermission(bytes32 permission, address account) internal virtual returns(bool) {
        return PublicAccessControl.inquiryAccountPermission(permission, account);
    }

    /**
     * @dev Modifiers used in organizational contracts. Only accounts with certain permissions are allowed in.
     * 
     * @notice Organizational contracts should use this.
     */
    modifier allowPermission(bytes32 permission) {
        require(PublicAccessControl.inquiryAccountPermission(
            permission, msg.sender), "AccessControlUtilities: You have no permission to access this function.");
        _;
    }

    /**
     * @dev Modifiers used in project contracts. 
     * 
     * Only accounts with certain permissions are allowed in. It queries both the organizational access control contract and the project access control contract and can be accessed as long as one of the permissions is met.
     * 
     * @notice Project contracts should use this.
     */
    modifier allowPermissions(bytes32 projectPermission, bytes32 organizationPermission) {
        require(PublicAccessControl.inquiryAccountPermission(
            projectPermission, 
            organizationPermission, 
            msg.sender
        ), "AccessControlUtilities: You have no permission to access this function.");
        _;
    }

    /**
     * @dev By calling this function during the initialization process of a derived contract, we can set the initial values of permissions that all functions have.
     */
    function _initializeFunctionPermission(bytes32 functionBytes, bytes32 permission) internal virtual {
        _functionPermission[functionBytes] = permission;
    }

    /**
     * @dev This function allows manager to modify the permissions of a function.
     */
    function _modifyFunctionPermission(bytes32 functionBytes, bytes32 permission) internal virtual {
        _functionPermission[functionBytes] = permission;
    }

    /**
     * @dev This function can be used to query the specific permissions of a function.
     */
    function _getFunctionPermission(bytes32 functionBytes) internal view virtual returns (bytes32) {
        return _functionPermission[functionBytes];
    }

}