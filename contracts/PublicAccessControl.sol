// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./IPublicAccessControl.sol";
import "./StringUtils.sol";


abstract contract PublicAccessControl is IPublicAccessControl{

    struct MembersData {
        mapping(address => bool) members;
        mapping(uint => address) index;
        uint number;
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
    bytes32 internal constant RECORD_MANAGER = keccak256("RECORD_MANAGER");
    bytes32 internal constant PROPOSAL_MANAGER = keccak256("PROPOSAL_MANAGER");

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
        return _allPermissions[permission].members[account];
    }

    //if the permission has already exist but just set false, do not need to change the index
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

    function _singleInit(bytes32 permission) private {
        _allPermissions[permission].isValid = true;
        _allPermissions[permission].members[msg.sender] = true;
        _allPermissions[permission].index[0] = msg.sender;
        _allPermissions[permission].number = 1;
        _indexOfPermissions[_numberOfPermissions] = permission;
        _numberOfPermissions++;
    }

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

    function _createPermission(bytes32 permission) internal virtual {
        //Every permissions should contain ADMIN all the time.
        _create(permission, ADMIN);
    }

    //create a new permission based on a permission already exist.
    //it is good for quick create some similar permissions.
    function _createPermissionByLevel(bytes32 permission, bytes32 permissionOriginal) internal virtual {
        _create(permission, permissionOriginal);
    }

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

    //grant permission to someone, only access manager (and admin) can access
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

    //revoke permission of someone, only access manager (and admin) can access
    function _revokeAccountPermission(bytes32 permission, address account) internal virtual {
        if (_check(permission, account) && !_check(ADMIN, account)) {
            _allPermissions[permission].members[account] = false;
            emit PermissionRevoked(permission, account, msg.sender);
        } else {
            _informFailure("The permission is not valid or the account is not in the permission.");
        }
    }

    //set account to false in every permissions
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

    function _transferAdmin(address account) internal virtual {
        _allPermissions[ADMIN].members[_inquiryAdmin()] = false;
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
        if(!_allPermissions[permission].isValid) {
            return false;
        } else {
            return _check(permission, account);
        }
    }

    //ingore if the permission is valid or not.
    function _inquiryAllAccountsByPermission(bytes32 permission) 
        internal view virtual 
        returns (address[] memory, bool[] memory) 
    {
        uint length = _allPermissions[permission].number;
        address[] memory relatedAccounts = new address[](length);
        bool[] memory relatedIsVailds = new bool[](length);
        // uint j = 0;
        for(uint i = 0; i < length; i++) {
            //Will not output members who are false.
            relatedAccounts[i] = _allPermissions[permission].index[i];
            relatedIsVailds[i] = _allPermissions[permission].members[_allPermissions[permission].index[i]];
            // if(_allPermissions[permission].members[_allPermissions[permission].index[i]]) {
            //     relatedAccounts[j] = _allPermissions[permission].index[i];
            //     j++;
            // }
        }
        return (relatedAccounts, relatedIsVailds);
    }

    //ingore if permissions are valid of not.
    function _inquiryAllPermissionsByAccount(address account) 
        internal view virtual 
        returns (bytes32[] memory, bool[] memory) 
    {
        bytes32[] memory relatedPermissions = new bytes32[](_numberOfPermissions);
        bool[] memory relatedIsVailds = new bool[](_numberOfPermissions);
        // uint j = 0;
        for(uint i = 0; i < _numberOfPermissions; i++) {
            relatedPermissions[i] = _indexOfPermissions[i];
            relatedIsVailds[i] = _allPermissions[_indexOfPermissions[i]].members[account];
            // if(_allPermissions[_indexOfPermissions[i]].members[account]) {
            //     relatedPermissions[j] = _indexOfPermissions[i];
            //     j++;
            // }
        }
        return (relatedPermissions, relatedIsVailds);
    }

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


    //For test, output _allPermissions completely as json
    function _outputStorage() internal view virtual returns(string memory) {
        string memory storageJson = "{";

        // uint[] mutiLength;

        // for(uint i = 0; i < _numberOfPermissions; i++) {
        //     bytes32 permission = _indexOfPermissions[i];
        //     uint oneLength = _allPermissions[permission].length;
        //     bool oneIsValid = _allPermissions[permission].isValid;
        //     storageJson = StringUtils.strConcat(storageJson, "\"length\":\"");
            // storageJson = StringUtils.strConcat(storageJson, StringUtils.toString(oneLength));
            // storageJson = StringUtils.strConcat(storageJson, "\",\"isValid\":");
            // if (oneIsValid) {
            //     storageJson = StringUtils.strConcat(storageJson, "true,\"members\":{");
            // } else {
            //     storageJson = StringUtils.strConcat(storageJson, "false,\"members\":{");
            // }

            // for(uint j = 0; j < oneLength; j++) {
            //     address oneAddress = _allPermissions[permission].index[j];
            //     bool oneBool = _allPermissions[permission].members[_allPermissions[permission].index[j]];
                // storageJson = StringUtils.strConcat(storageJson, "\"");
                // storageJson = StringUtils.strConcat(storageJson, StringUtils.toString(oneAddress));
                // storageJson = StringUtils.strConcat(storageJson, "\":");
                // if (oneBool) {
                //     storageJson = StringUtils.strConcat(storageJson, "true,");
                // } else {
                //     storageJson = StringUtils.strConcat(storageJson, "false,");
                // }
                // storageJson = StringUtils.strConcat(storageJson, "}},");
            // }
        // }
        // storageJson = StringUtils.strConcat(storageJson, "}");


        return(storageJson);
    }


}