// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";

import "../PublicAccessUtils.sol";

contract ProjectToken is PublicAccessUtils, ERC20Votes {

    bytes32 internal constant TOKEN_MANAGER = keccak256("TOKEN_MANAGER");
    bytes32 internal constant PROPOSAL_MANAGER = keccak256("PROPOSAL_MANAGER");
    
    constructor(address projectAccessControlAddress, string memory TokenName, string memory TokenSymbol) 
        ERC20(TokenName, TokenSymbol) ERC20Permit(TokenName) 
    {
        _initializeAccessControl(projectAccessControlAddress);
    }

    function totalSupply() 
        public view override allowPermissions(STAFF, STAFF) returns (uint256) 
    {
        return super.totalSupply();
    }

    function balanceOf(address account) 
        public view override allowPermissions(TOKEN_MANAGER, ADMIN) returns (uint256) 
    {
        return super.balanceOf(account);
    }

    // //STAFF can't transfer their token
    // function transfer(address to, uint256 amount) 
    //     public override allowPermissions(STAFF, STAFF) returns (bool) 
    // {
    //     require(false, "The function is not avaliable.");
    //     return super.transfer(to, amount);
    // }

    //only TOKEN_MANAGER can transfer everyone's token
    function transfer(address owner, address to, uint256 amount) 
        public allowPermissions(TOKEN_MANAGER, ADMIN)
    {
        return super._transfer(owner, to, amount);
    }

    
    // function allowance(address owner, address spender) 
    //     public view override allowPermissions(STAFF, STAFF) returns (uint256) 
    // {
    //     require(false, "The function is not avaliable.");
    //     return super.allowance(owner, spender);
    // }

    // function approve(address spender, uint256 amount) 
    //     public override allowPermissions(STAFF, STAFF) returns (bool) 
    // {
    //     require(false, "The function is not avaliable.");
    //     return super.approve(spender, amount);
    // }


    // function transferFrom(address from, address to, uint256 amount) 
    //     public override allowPermissions(STAFF, STAFF) returns (bool) 
    // {
    //     require(false, "The function is not avaliable.");
    //     return super.transferFrom(from, to, amount);
    // }

    //IERC20Metadata
    function name() 
        public view override 
        allowPermissions(MEMBER, MEMBER) returns (string memory) 
    {
        return super.name();
    }

    function symbol() 
        public view override 
        allowPermissions(MEMBER, MEMBER) returns (string memory) 
    {
        return super.symbol();
    }

    function decimals() 
        public view override 
        allowPermissions(MEMBER, MEMBER) returns (uint8) 
    {
        return super.decimals();
    }

    //IVotes
    function getVotes(address account) 
        public view override 
        allowPermissions(PROPOSAL_MANAGER, ADMIN) returns (uint256) 
    {
        return super.getVotes(account);
    }

    function getPastVotes(address account, uint256 blockNumber) 
        public view override 
        allowPermissions(PROPOSAL_MANAGER, ADMIN) returns (uint256) 
    {
        return super.getPastVotes(account, blockNumber);
    }

    function getPastTotalSupply(uint256 blockNumber) 
        public view override 
        allowPermissions(PROPOSAL_MANAGER, ADMIN) returns (uint256)
    {
        return super.getPastTotalSupply(blockNumber);
    }

    function delegates(address account) 
        public view override allowPermissions(STAFF, STAFF) returns (address) 
    {
        return super.delegates(account);
    }

    function delegate(address delegatee) 
        public override allowPermissions(TOKEN_MANAGER, STAFF)
    {
        return super.delegate(delegatee);
    }

    function delegateBySig(
        address delegatee,
        uint256 nonce,
        uint256 expiry,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public override allowPermissions(STAFF, STAFF) {
        require(false, "The function is not avaliable.");
        return super.delegateBySig(delegatee, nonce, expiry, v, r, s);
    }

    //IERC20Permit
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public override allowPermissions(TOKEN_MANAGER, ADMIN) {
        return super.permit(owner, spender, value, deadline, v, r, s);
    }

    function nonces(address owner) 
        public view override allowPermissions(STAFF, STAFF) returns (uint256)
    {
        return super.nonces(owner);
    }

    //cannot access by interface
    function increaseAllowance(address spender, uint256 addedValue) 
        public override allowPermissions(STAFF, STAFF) returns (bool) 
    {
        require(false, "The function is not avaliable.");
        return super.increaseAllowance(spender, addedValue);
    }

    // function decreaseAllowance(address spender, uint256 subtractedValue) 
    //     public override allowPermissions(STAFF, STAFF) returns (bool) 
    // {
    //     require(false, "The function is not avaliable.");
    //     return super.decreaseAllowance(spender, subtractedValue);
    // }

    //internal functions
    function mint(address account, uint256 amount) 
        public allowPermissions(TOKEN_MANAGER, ADMIN) 
    {
        _mint(account, amount);
    }

    function burn(address account, uint256 amount) 
        public allowPermissions(TOKEN_MANAGER, ADMIN) 
    {
        _burn(account, amount);
    }



}