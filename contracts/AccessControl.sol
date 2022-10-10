// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./IAccessControl.sol";


abstract contract AccessControl is IAccessControl{

    struct MembersData {
        mapping(address => bool) members;
        mapping(uint => address) index;
        uint length;
        bool isValid;
    }
    mapping(bytes32 => MembersData) private _allPermissions;
    //index of _allPermissions
    mapping(uint => bytes32) private _indexOfPermissions;
    uint private _numberOfPermissions;


    // MANAGER contains ADMIN and all kinds of managers
    // STAFF contains MANAGER
    // MEMBER contains STAFF and VISITOR
    bytes32 internal constant ADMIN = keccak256("ADMIN");
    bytes32 internal constant MANAGER = keccak256("MANAGER");
    bytes32 internal constant STAFF = keccak256("STAFF");
    bytes32 internal constant MEMBER = keccak256("MEMBER");

    // Some functions that may only contracts can call
    bytes32 internal constant CONTRACT = keccak256("CONTRACT");

    //..._MANAGER
    bytes32 internal constant TOKEN_MANAGER = keccak256("TOKEN_MANAGER");
    bytes32 internal constant ACCESS_MANAGER = keccak256("ACCESS_MANAGER");


    // modifier allowPermission(bytes32 permission) {
    //     require(_check(permission, msg.sender), "AccessControl: You have no permission to access this function.");
    //     _;
    // }

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

    function _check(bytes32 permission, address account) internal view virtual returns (bool) {
        if(_allPermissions[permission].isValid == false) {
            return false;
        } else {
            return _allPermissions[permission].members[account];
        }
    }

    //if the permission has already exist but just set false, do not need to change the index
    function _changePermissionIndex(bytes32 permission) private {
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
        }
    }

    function _singleInit(bytes32 permission) private {
        _allPermissions[permission].isValid = true;
        _allPermissions[permission].members[msg.sender] = true;
        _allPermissions[permission].index[0] = msg.sender;
        _allPermissions[permission].length = 1;
        _indexOfPermissions[_numberOfPermissions] = permission;
        _numberOfPermissions++;
    }

    function _initialize() internal virtual {
        _numberOfPermissions = 0;
        _singleInit(ADMIN);
        _singleInit(ACCESS_MANAGER);
        _singleInit(TOKEN_MANAGER);
        _singleInit(STAFF);
        _singleInit(MEMBER);
    }

    function _createPermission(bytes32 permission) internal virtual {
        // bytes32 permission = keccak256(bytes(permissionName));
        if (!_allPermissions[permission].isValid) {
            _changePermissionIndex(permission);
            _allPermissions[permission].isValid = true;
            //Every permissions should contain ADMIN all the time.
            for(uint i = 0; i < _allPermissions[ADMIN].length; i++) {
                address indexOfAddress = _allPermissions[ADMIN].index[i];
                _allPermissions[permission].members[indexOfAddress] = _allPermissions[ADMIN].members[indexOfAddress];
                _allPermissions[permission].index[i] = indexOfAddress;
            }
            _allPermissions[permission].length = _allPermissions[ADMIN].length;
            emit PermissionCreated(permission, msg.sender);
        } else {
            _informFailure("The permission has alreay exist.");
        }
    }

    //create a new permission based on a permission already exist.
    //it is good for quick create some similar permissions.
    function _createPermissionByLevel(bytes32 permission, bytes32 permissionA) internal virtual {
        // bytes32 permission = keccak256(bytes(permissionName));
        // bytes32 permissionA = keccak256(bytes(permissionAlready));
        if (!_allPermissions[permission].isValid) {
            _changePermissionIndex(permission);
            _allPermissions[permission].isValid = true;
            //copy data from permissionAlready
            for(uint i = 0; i < _allPermissions[permissionA].length; i++) {
                address indexOfAddress = _allPermissions[permissionA].index[i];
                _allPermissions[permission].members[indexOfAddress] = _allPermissions[permissionA].members[indexOfAddress];
                _allPermissions[permission].index[i] = indexOfAddress;
            }
            _allPermissions[permission].length = _allPermissions[permissionA].length;
            emit PermissionCreated(permission, msg.sender);
        } else {
            _informFailure("The permission has alreay exist.");
        }
    }

    function _deletePermission(bytes32 permission) internal virtual {
        // bytes32 permission = keccak256(bytes(permissionName));
        if (_allPermissions[permission].isValid && permission != ADMIN) {
            //isValid to false will not change the index of _allPermissions.
            _allPermissions[permission].isValid = false;
            emit PermissionDeleted(permission, msg.sender);
        } else {
            _informFailure("The permission is not valid.");
        }
    }

    function _changeAccountIndex(bytes32 permission, address account) private {
        //to check if the account has already existed
        //If it has then the index don't need to change, otherwise the index need to add it
        bool isExist = false;
        for(uint i = 0; i < _allPermissions[permission].length; i++) {
            if(_allPermissions[permission].index[i] == account) {
                isExist = true;
                break;
            }
        }
        if(!isExist) {
            _allPermissions[permission].index[_allPermissions[permission].length] = account;
            _allPermissions[permission].length++;
        }
    }

    //grant permission to someone, only access manager (and admin) can access
    function _grantAccountPermission(bytes32 permission, address account) internal virtual {
        // bytes32 permission = keccak256(bytes(permissionName));
        //have to createPermission first, and then to grantAccountPermission
        if (_allPermissions[permission].isValid && permission != ADMIN) {
            _changeAccountIndex(permission, account);
            _allPermissions[permission].members[account] = true;
            emit PermissionGranted(permission, account, msg.sender);
        } else {
            _informFailure("The permission is not valid.");
        }
    }

    //revoke permission of someone, only access manager (and admin) can access
    function _revokeAccountPermission(bytes32 permission, address account) internal virtual {
        // bytes32 permission = keccak256(bytes(permissionName));
        if (_check(permission, account) && permission != ADMIN) {
            _allPermissions[permission].members[account] = false;
            emit PermissionRevoked(permission, account, msg.sender);
        } else {
            _informFailure("The permission is not valid or the account is not in the permission.");
        }
    }

    //set account to false in every permissions
    function _deleteAccount(address account) internal virtual {
        //if the account is ADMIN and msg.sender is not ADMIN, it cannot change
        if(!_check(ADMIN, account) || _check(ADMIN, msg.sender)) {
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

    function _transferAdmin(address account) internal virtual {
        _allPermissions[ADMIN].members[msg.sender] = false;
        _changeAccountIndex(ADMIN, account);
        _allPermissions[ADMIN].members[account] = true;
        emit AdminTransfered(account, msg.sender);
    }

    //check if the role contains the address, only organizational members can inqiury
    //can be used by outside contracts (contracts address should be added in STAFF by managers)
    function _inquiryAccountPermission(bytes32 permission, address account) 
        internal view virtual 
        returns (bool) 
    {
        return _check(permission, account);
    }

    function _inquiryAllPermissionsByAccount(address account) 
        internal view virtual 
        returns (bytes32[] memory) 
    {
        bytes32[] memory relatedPermissions;
        uint j = 0;
        for(uint i = 0; i < _numberOfPermissions; i++) {
            if(_allPermissions[_indexOfPermissions[i]].members[account]) {
                relatedPermissions[j] = _indexOfPermissions[i];
                j++;
            }
        }
        return relatedPermissions;
    }

    function _inquiryAllAccountsByPermission(bytes32 permission) 
        internal view virtual 
        returns (address[] memory) 
    {
        address[] memory relatedAccounts;
        // bytes32 permission = keccak256(bytes(permissionName));
        uint j = 0;
        for(uint i = 0; i < _allPermissions[permission].length; i++) {
            //Will not output members who are false.
            if(_allPermissions[permission].members[_allPermissions[permission].index[i]]) {
                relatedAccounts[j] = _allPermissions[permission].index[i];
                j++;
            }
        }
        return relatedAccounts;
    }

    function _inquiryAdmin() internal view virtual returns (address) {
        uint i = 0;
        for(; i < _allPermissions[ADMIN].length; i++) {
            if(_allPermissions[ADMIN].members[_allPermissions[ADMIN].index[i]]) {
                break;
            }
        }
        return _allPermissions[ADMIN].index[i];
    }


}