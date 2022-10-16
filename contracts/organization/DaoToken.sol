// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
// import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";

import "../AccessUtils.sol";

contract DaoToken is AccessUtils, ERC20Votes {
    
    // string internal constant TokenName = "";
    // string internal constant TokenSymbol = "";


    constructor(address daoAccessControlAddress, string memory TokenName, string memory TokenSymbol) 
        ERC20(TokenName, TokenSymbol) ERC20Permit(TokenName) 
    {
        _initializeAccessControl(daoAccessControlAddress);
    }

    //IERC20
    function totalSupply() 
        public view override allowPermission(TOKEN_MANAGER) returns (uint256) 
    {
        return super.totalSupply();
    }

    function balanceOf(address account) 
        public view override allowPermission(TOKEN_MANAGER) returns (uint256) 
    {
        return super.balanceOf(account);
    }

    function transfer(address to, uint256 amount) 
        public override allowPermission(TOKEN_MANAGER) returns (bool) 
    {
        return super.transfer(to, amount);
    }

    function allowance(address owner, address spender) 
        public view override allowPermission(TOKEN_MANAGER) returns (uint256) 
    {
        return super.allowance(owner, spender);
    }

    function approve(address spender, uint256 amount) 
        public override allowPermission(TOKEN_MANAGER) returns (bool) 
    {
        return super.approve(spender, amount);
    }

    function transferFrom(address from, address to, uint256 amount) 
        public override allowPermission(TOKEN_MANAGER) returns (bool) 
    {
        return super.transferFrom(from, to, amount);
    }

    //IERC20Metadata
    function name() 
        public view override allowPermission(TOKEN_MANAGER) returns (string memory) 
    {
        return super.name();
    }

    function symbol() 
        public view override allowPermission(TOKEN_MANAGER) returns (string memory) 
    {
        return super.symbol();
    }

    function decimals() 
        public view override allowPermission(TOKEN_MANAGER) returns (uint8) 
    {
        return super.decimals();
    }

    //IVotes
    function getVotes(address account) 
        public view override allowPermission(TOKEN_MANAGER) returns (uint256) 
    {
        return super.getVotes(account);
    }

    function getPastVotes(address account, uint256 blockNumber) 
        public view override allowPermission(TOKEN_MANAGER) returns (uint256) 
    {
        return super.getPastVotes(account, blockNumber);
    }

    function getPastTotalSupply(uint256 blockNumber) 
        public view override allowPermission(TOKEN_MANAGER) returns (uint256)
    {
        return super.getPastTotalSupply(blockNumber);
    }

    function delegates(address account) 
        public view override allowPermission(TOKEN_MANAGER) returns (address) 
    {
        return super.delegates(account);
    }

    function delegate(address delegatee) 
        public override allowPermission(TOKEN_MANAGER)
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
    ) public override allowPermission(TOKEN_MANAGER) {
        return super.delegateBySig(delegatee, nonce, expiry, v, r, s);
    }

    //cannot access by interface
    function increaseAllowance(address spender, uint256 addedValue) 
        public override allowPermission(TOKEN_MANAGER) returns (bool) 
    {
        return super.increaseAllowance(spender, addedValue);
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) 
        public override allowPermission(TOKEN_MANAGER) returns (bool) 
    {
        return super.decreaseAllowance(spender, subtractedValue);
    }

    //internal functions
    function mint(address account, uint256 amount) 
        public allowPermission(TOKEN_MANAGER) 
    {
        _mint(account, amount);
    }

    function burn(address account, uint256 amount) 
        public allowPermission(TOKEN_MANAGER) 
    {
        _burn(account, amount);
    }


}