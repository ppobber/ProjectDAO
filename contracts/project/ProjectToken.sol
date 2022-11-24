// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";

import "../PublicAccessUtils.sol";

/**
 * @dev This is the project token contract.
 *
 * See {DaoToken}.
 */
contract ProjectToken is PublicAccessUtils, ERC20Votes {

    bytes32 internal constant TOKEN_MANAGER = keccak256("TOKEN_MANAGER");
    bytes32 internal constant PROPOSAL_MANAGER = keccak256("PROPOSAL_MANAGER");
    
    constructor(address projectAccessControlAddress, string memory projectTokenName, string memory projectTokenSymbol) 
        ERC20(projectTokenName, projectTokenSymbol) ERC20Permit(projectTokenName) 
    {
        _initializeAccessControl(projectAccessControlAddress);
    }

    /**
    * @dev See {DaoToken-totalSupply}.
    */
    function totalSupply() 
        public view override allowPermissions(STAFF, STAFF) returns (uint256) 
    {
        return super.totalSupply();
    }

    /**
    * @dev See {DaoToken-balanceOf}.
    */
    function balanceOf(address account) 
        public view override allowPermissions(TOKEN_MANAGER, ADMIN) returns (uint256) 
    {
        return super.balanceOf(account);
    }

    /**
    * @dev See {DaoToken-transferFrom}.
    */
    function transferFrom(address from, address to, uint256 amount) 
        public override allowPermissions(TOKEN_MANAGER, ADMIN) returns (bool)
    {
        super._transfer(from, to, amount);
        return true;
    }

    /**
    * @dev See {DaoToken-name}.
    */
    function name() 
        public view override 
        allowPermissions(MEMBER, MEMBER) returns (string memory) 
    {
        return super.name();
    }

    /**
    * @dev See {DaoToken-symbol}.
    */
    function symbol() 
        public view override 
        allowPermissions(MEMBER, MEMBER) returns (string memory) 
    {
        return super.symbol();
    }

    /**
    * @dev See {DaoToken-decimals}.
    */
    function decimals() 
        public view override 
        allowPermissions(MEMBER, MEMBER) returns (uint8) 
    {
        return super.decimals();
    }

    /**
    * @dev See {DaoToken-getVotes}.
    */
    function getVotes(address account) 
        public view override 
        allowPermissions(PROPOSAL_MANAGER, ADMIN) returns (uint256) 
    {
        return super.getVotes(account);
    }

    /**
    * @dev See {DaoToken-getPastVotes}.
    */
    function getPastVotes(address account, uint256 blockNumber) 
        public view override 
        allowPermissions(PROPOSAL_MANAGER, ADMIN) returns (uint256) 
    {
        return super.getPastVotes(account, blockNumber);
    }

    /**
    * @dev See {DaoToken-getPastTotalSupply}.
    */
    function getPastTotalSupply(uint256 blockNumber) 
        public view override 
        allowPermissions(PROPOSAL_MANAGER, ADMIN) returns (uint256)
    {
        return super.getPastTotalSupply(blockNumber);
    }

    /**
    * @dev See {DaoToken-delegates}.
    */
    function delegates(address account) 
        public view override allowPermissions(STAFF, STAFF) returns (address) 
    {
        return super.delegates(account);
    }

    /**
    * @dev See {DaoToken-delegate}.
    */
    function delegate(address delegatee) 
        public override allowPermissions(TOKEN_MANAGER, STAFF)
    {
        return super.delegate(delegatee);
    }

    /**
    * @dev See {DaoToken-delegateFrom}.
    */
    function delegateFrom(address delegator, address delegatee) 
        public allowPermissions(TOKEN_MANAGER, STAFF)
    {
        return super._delegate(delegator, delegatee);
    }

    /**
    * @dev See {DaoToken-delegateBySig}.
    */
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

    /**
    * @dev See {DaoToken-permit}.
    */
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

    /**
    * @dev See {DaoToken-nonces}.
    */
    function nonces(address owner) 
        public view override allowPermissions(STAFF, STAFF) returns (uint256)
    {
        return super.nonces(owner);
    }

    /**
    * @dev See {DaoToken-increaseAllowance}.
    */
    function increaseAllowance(address spender, uint256 addedValue) 
        public override allowPermissions(STAFF, STAFF) returns (bool) 
    {
        require(false, "The function is not avaliable.");
        return super.increaseAllowance(spender, addedValue);
    }

    /**
    * @dev See {DaoToken-mint}.
    */    
    function mint(address account, uint256 amount) 
        public allowPermissions(TOKEN_MANAGER, ADMIN) 
    {
        super._mint(account, amount);
    }

    /**
    * @dev See {DaoToken-burn}.
    */
    function burn(address account, uint256 amount) 
        public allowPermissions(TOKEN_MANAGER, ADMIN) 
    {
        super._burn(account, amount);
    }

}