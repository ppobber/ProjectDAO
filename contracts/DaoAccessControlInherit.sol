// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "./IDaoAccessControlInherit.sol";

contract DaoAccessControlInherit is AccessControl, IDaoAccessControlInherit{

    mapping (address => bool) private _daoMembers;
    mapping (address => bool) private _daoVisitors;
    mapping (address => bool) private _daoContracts;

    // bytes32 public constant USER_ROLE = keccak256("USER_ROLE");
    bytes32 internal constant TOKEN_MANAGER_ROLE = keccak256("TOKEN_MANAGER_ROLE");
    bytes32 internal constant ACCESS_MANAGER_ROLE = keccak256("ACCESS_MANAGER_ROLE");
    //...MANAGER_ROLE

    bytes32 internal constant STAFF_ROLE = keccak256("STAFF_ROLE");
    bytes32 internal constant VISITOR_ROLE = keccak256("VISITOR_ROLE");



    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _daoMembers[_msgSender()] = true;
    }


    modifier onlyAdmin() {
        require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "AccessControl: You have no permission to use this function.");
        _;
    }

    modifier allowAccessManager() {
        bool ifallow = hasRole(DEFAULT_ADMIN_ROLE, _msgSender()) || hasRole(ACCESS_MANAGER_ROLE, _msgSender());
        require(ifallow, "AccessControl: You have no permission to use this function.");
        _;
    }

    modifier allowStaff() {
        bool ifallow = _daoMembers[_msgSender()];
        require(ifallow, "AccessControl: You have no permission to use this function.");
        _;
    }

    modifier allowVisitor() {
        //todo
        _;
    }

    modifier onlyContracts() {
        //to test
        bool ifallow = _daoContracts[_msgSender()];
        require(ifallow, "AccessControl: This address have no permission to use this function.");
        _;
    }

    //to fix
    // All contracts that inherit from this contract {DaoAccessControl} need to synchronize their access control data when the access control information change
    // function _synchronizeData() public
    //     returns(
    //         mapping (address => bool), 
    //         mapping (address => bool), 
    //         mapping (bytes32 => RoleData)
    //     ) {
    //     return (_daoMembers, _daoVisitors, _roles);
    // }




    //check if the role contains the address, only organizational contracts can inqiury
    function inquiryAddressPermission(bytes32 permission,address account) 
        public 
        view 
        onlyContracts returns(bool) {
        return hasRole(permission, account);
    }

    function transferAdmin(address _newAdmin) public onlyAdmin {
        _revokeRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _grantRole(DEFAULT_ADMIN_ROLE, _newAdmin);
    }

    //
    function grantPermission(bytes32 permission, address _staff) public allowAccessManager {
        if(!_daoMembers[_staff]) {
            _daoMembers[_staff] = true;
        }
        _grantRole(permission, _staff);
    }

    function revokePermission(bytes32 permission, address _staff) public allowAccessManager {
        _revokeRole(permission, _staff);
    }

    function revokeStaff() public allowAccessManager {

    }

    function transferPermission(
        bytes32 permission, 
        address _oldStaff, 
        address _newStaff
    ) public allowAccessManager {
        _revokeRole(permission, _oldStaff);
        _grantRole(permission, _newStaff);
    }

    //openzepplin allow users revoke themself, it's forbidden in our project.
    function renounceRole() private {}

    
}