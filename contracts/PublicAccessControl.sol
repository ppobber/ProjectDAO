// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./IPublicAccessControl.sol";
import "./StringUtils.sol";

/**
 * @dev The contract includes a complete set of access control capabilities. 
 *
 * On top of that, the organizational access control contract is sent to the project access control contract. And all other contracts need code that relies on that contract functionally. Because they need to check the account access permission.
 */
abstract contract PublicAccessControl is IPublicAccessControl{

    struct MembersData {
        mapping(address => bool) members;
        mapping(uint => address) index;
        uint number;
        bool isValid;
    }
    mapping(bytes32 => MembersData) private _allPermissions;
    mapping(uint => bytes32) private _indexOfPermissions;
    uint private _numberOfPermissions;

    /**
     * @dev Has access and call rights to all content, all functions. Some important functions can only be accessed by the administrator.
     */
    bytes32 internal constant ADMIN = keccak256("ADMIN");

    /**
     * @dev Be seen as an average employee in an organization. It has query rights for most of the content, and call rights for some of the content.
     */
    bytes32 internal constant STAFF = keccak256("STAFF");

    /**
     * @dev Is considered an employee outside the organization, but is indirectly associated with the project. Such as stakeholders, negotiators from partner organizations, etc. They can query some content but cannot modify any data.
     * But this sign is not currently used in any of our contracts.
     */
    bytes32 internal constant MEMBER = keccak256("MEMBER");

    /**
     * @dev A permission specifically provided for contract access. But it has not yet been used in our contracts.
     * But this sign is not currently used in any of our contracts.
     */
    bytes32 internal constant CONTRACT = keccak256("CONTRACT");

    /**
     * @dev Be seen as the top management in the organization and have authority over all management content. 
     * But this sign is not currently used in any of our contracts.
     */
    bytes32 internal constant MANAGER = keccak256("MANAGER");

    /**
     * @dev Be regarded as the manager of the token contract. It can be compared to financial accounting and auditing in reality.
     */
    bytes32 internal constant TOKEN_MANAGER = keccak256("TOKEN_MANAGER");

    /**
     * @dev Be regarded as the manager of the access control contract. It can be compared to the human resource scheduler in reality.
     */
    bytes32 internal constant ACCESS_MANAGER = keccak256("ACCESS_MANAGER");

    /**
     * @dev Be regarded as the manager of the record of the contract. It can be compared to the information gatherer and inputer in reality.
     */
    bytes32 internal constant RECORD_MANAGER = keccak256("RECORD_MANAGER");

    /**
     * @dev Be regarded as the manager of the proposal contract and the proposal record contract. It can be compared to the co-ordinator in reality.
     */
    bytes32 internal constant PROPOSAL_MANAGER = keccak256("PROPOSAL_MANAGER");

    /**
     * @dev A function that makes it easy to print formatted error messages.
     */
    function _informFailure(string memory response) private pure {
        revert(
            string(
                abi.encodePacked(
                    "AccessControl: ",
                    response
                )
            )
        );
    }

    /**
     * @dev A private function to query account permissions.
     */
    function _check(bytes32 permission, address account) internal view virtual returns (bool) {
        return _allPermissions[permission].members[account];
    }

    /**
     * @dev A private function that modifies the permission index. This function is called when a new permission is added. 
     *
     * @notice This function is called only when it has been added.
     */
    function _changePermissionIndex(bytes32 permission) private returns (bool) {
        bool isExist = false;
        for(uint i = 0; i < _numberOfPermissions; i++) {
            if(_indexOfPermissions[i] == permission) {
                isExist = true;
                break;
            }
        }
        if(!isExist) {
            _indexOfPermissions[_numberOfPermissions] = permission;
            _numberOfPermissions++;
            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev During initialization, add a specific permission. The default sender for creating a contract is admin.
     */
    function _singleInit(bytes32 permission) private {
        _allPermissions[permission].isValid = true;
        _allPermissions[permission].members[msg.sender] = true;
        _allPermissions[permission].index[0] = msg.sender;
        _allPermissions[permission].number = 1;
        _indexOfPermissions[_numberOfPermissions] = permission;
        _numberOfPermissions++;
    }

    /**
     * @dev During the initialization, some permissions are created in advance and all permissions are assigned to admin.
     */
    function _initialize() internal virtual {
        _numberOfPermissions = 0;
        _singleInit(ADMIN);
        _singleInit(ACCESS_MANAGER);
        _singleInit(TOKEN_MANAGER);
        _singleInit(RECORD_MANAGER);
        _singleInit(PROPOSAL_MANAGER);
        _singleInit(STAFF);
        _singleInit(MEMBER);
    }

    /**
     * @dev Create a new permission. 
     *
     * @notice Must first create a specific permission and than can grant an account that permission based on it.
     */
    function _createPermission(bytes32 permission) internal virtual {
        //Every permissions should contain ADMIN all the time.
        _create(permission, ADMIN);
    }

    /**
     * @dev Create a new permission based on an existing permission. 
     *
     *The new permission copies all the content of the existing permission. This function is used for some similar business where only a few people change. Then we do not have to add users one by one, which can save some time.
     */
    function _createPermissionByLevel(bytes32 permission, bytes32 permissionOriginal) internal virtual {
        _create(permission, permissionOriginal);
    }

    /**
     * @dev Create a private function for permissions.
     */
    function _create(bytes32 permission, bytes32 permissionA) private {
        if (!_allPermissions[permission].isValid) {
            _allPermissions[permission].isValid = true;
            if(_changePermissionIndex(permission)) {
                //copy data from permissionA
                for(uint i = 0; i < _allPermissions[permissionA].number; i++) {
                    address indexOfAddress = _allPermissions[permissionA].index[i];
                    _allPermissions[permission].members[indexOfAddress] = _allPermissions[permissionA].members[indexOfAddress];
                    _allPermissions[permission].index[i] = indexOfAddress;
                }
                _allPermissions[permission].number = _allPermissions[permissionA].number;
            } else {
                for(uint i = 0; i < _allPermissions[permissionA].number; i++) {
                    address indexOfAddress = _allPermissions[permissionA].index[i];
                    _allPermissions[permission].members[indexOfAddress] = _allPermissions[permissionA].members[indexOfAddress];
                    _changeAccountIndex(permission, indexOfAddress);
                }
                _allPermissions[permission].number += _allPermissions[permissionA].number;
            }
            emit PermissionCreated(permission, permissionA, msg.sender);
        } else {
            _informFailure("The permission has alreay exist.");
        }
    }

    /**
     * @dev Delete a permission. The boolean value in the structure that determines whether it is valid is set to false. 
     *
     * @notice Deleting permissions does not change the index.
     */
    function _deletePermission(bytes32 permission) internal virtual {
        if (_allPermissions[permission].isValid && permission != ADMIN) {
            for(uint i = 0; i < _allPermissions[permission].number; i++) {
                _allPermissions[permission].members[_allPermissions[permission].index[i]] = false;
            }
            _allPermissions[permission].isValid = false;
            emit PermissionDeleted(permission, msg.sender);
        } else {
            _informFailure("The permission is not valid or the permission is ADMIN.");
        }
    }

    /**
     * @dev A private function to modify the account index. This function is called when there is a new account in the list of permissions. 
     *
     * @notice This function is called only when a new account is added.
     */
    function _changeAccountIndex(bytes32 permission, address account) private {
        //to check if the account has already existed
        //If it has then the index don't need to change, otherwise the index need to add it
        bool isExist = false;
        for(uint i = 0; i < _allPermissions[permission].number; i++) {
            if(_allPermissions[permission].index[i] == account) {
                isExist = true;
                break;
            }
        }
        if(!isExist) {
            _allPermissions[permission].index[_allPermissions[permission].number] = account;
            _allPermissions[permission].number++;
        }
    }

    /**
     * @dev Grant a specific permission to an account.
     */
    function _grantAccountPermission(bytes32 permission, address account) internal virtual {
        //have to createPermission first, and then to grantAccountPermission
        if (_allPermissions[permission].isValid && permission != ADMIN) {
            _changeAccountIndex(permission, account);
            _allPermissions[permission].members[account] = true;
            emit PermissionGranted(permission, account, msg.sender);
        } else {
            _informFailure("The permission is not valid.");
        }
    }

    /**
     * @dev Revokes a permission that an account has.
     */
    function _revokeAccountPermission(bytes32 permission, address account) internal virtual {
        if (_check(permission, account) && !_check(ADMIN, account)) {
            _allPermissions[permission].members[account] = false;
            emit PermissionRevoked(permission, account, msg.sender);
        } else {
            _informFailure("The permission is not valid or the account is not in the permission.");
        }
    }

    /**
     * @dev Revoking all permissions for an account at once. 
     *
     * The revoke function can removes the account's privileges one by one, but this function is faster.
     */
    function _deleteAccount(address account) internal virtual {
        if(!_check(ADMIN, account)) {
            //start from 1, becasue _indexOfPermissions[0] is ADMIN
            for(uint i = 1; i < _numberOfPermissions; i++) {
                if(_allPermissions[_indexOfPermissions[i]].members[account]){
                    _allPermissions[_indexOfPermissions[i]].members[account] = false;
                }
            }
        emit AccountDeleted(account, msg.sender);
        } else {
            _informFailure("You cannot delete ADMIN.");
        }
    }

    /**
     * @dev Transfer admin to another user. 
     *
     * This function is accessible only by admin.
     */
    function _transferAdmin(address account) internal virtual {
        _allPermissions[ADMIN].members[_inquiryAdmin()] = false;
        _changeAccountIndex(ADMIN, account);
        _allPermissions[ADMIN].members[account] = true;
        emit AdminTransfered(account, msg.sender);
    }

    /**
     * @dev See {IPublicAccessControl-inquiryAccountPermission}.
     */
    function _inquiryAccountPermission(bytes32 permission, address account) 
        internal view virtual 
        returns (bool) 
    {
        if(!_allPermissions[permission].isValid) {
            return false;
        } else {
            return _check(permission, account);
        }
    }

    /**
     * @dev See {IPublicAccessControl-inquiryAllAccountsByPermission}.
     */
    function _inquiryAllAccountsByPermission(bytes32 permission) 
        internal view virtual 
        returns (address[] memory, bool[] memory) 
    {
        uint length = _allPermissions[permission].number;
        address[] memory relatedAccounts = new address[](length);
        bool[] memory relatedIsVailds = new bool[](length);
        for(uint i = 0; i < length; i++) {
            //Will not output members who are false.
            relatedAccounts[i] = _allPermissions[permission].index[i];
            relatedIsVailds[i] = _allPermissions[permission].members[_allPermissions[permission].index[i]];
        }
        return (relatedAccounts, relatedIsVailds);
    }

    /**
     * @dev See {IPublicAccessControl-inquiryAllPermissionsByAccount}.
     */
    function _inquiryAllPermissionsByAccount(address account) 
        internal view virtual 
        returns (bytes32[] memory, bool[] memory) 
    {
        bytes32[] memory relatedPermissions = new bytes32[](_numberOfPermissions);
        bool[] memory relatedIsVailds = new bool[](_numberOfPermissions);
        for(uint i = 0; i < _numberOfPermissions; i++) {
            relatedPermissions[i] = _indexOfPermissions[i];
            relatedIsVailds[i] = _allPermissions[_indexOfPermissions[i]].members[account];
        }
        return (relatedPermissions, relatedIsVailds);
    }

    /**
     * @dev See {IPublicAccessControl-inquiryAllPermissions}.
     */
    function _inquiryAllPermissions() 
        internal view virtual 
        returns (bytes32[] memory, bool[] memory) 
    {
        bytes32[] memory relatedPermissions = new bytes32[](_numberOfPermissions);
        bool[] memory relatedIsVailds = new bool[](_numberOfPermissions);
        for(uint i = 0; i < _numberOfPermissions; i++) {
            relatedPermissions[i] = _indexOfPermissions[i];
            relatedIsVailds[i] = _allPermissions[_indexOfPermissions[i]].isValid;
        }
        return (relatedPermissions, relatedIsVailds);
    }

    /**
     * @dev See {IPublicAccessControl-inquiryAdmin}.
     */
    function _inquiryAdmin() internal view virtual returns (address) 
    {
        uint i = 0;
        for(; i < _allPermissions[ADMIN].number; i++) {
            if(_allPermissions[ADMIN].members[_allPermissions[ADMIN].index[i]]) {
                break;
            }
        }
        return _allPermissions[ADMIN].index[i];
    }

}