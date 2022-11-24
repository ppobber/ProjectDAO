// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";

import "../PublicAccessUtils.sol";

/**
 * @dev The organization's token contract is inherited from openzeppelin's ERC20 contract and its voting extension. Because ERC20 has become widely popular in the world as the most universal token template. So we use ERC20 tokens as the token model of our project to avoid a lot of unnecessary troubles, such as compatibility issues. 
 *
 * We also considered ERC721 tokens and ERC1155 tokens, but all things considered, ERC20 is still the preferred choice for now. Subsequent teams can add more token types if they wish. ERC721 and ERC1155 also have many new functions to deal with different scenarios, and can also make up for many problems in performance and security of ERC20.
 *
 * ERC20Votes is an extension of the ERC20 contract, which is entirely for the governor contract, so we're using the governor contract, which makes perfect sense to use the ERC20Votes extension. This contract keeps track of the token flow of the delegator, so that it can get the voting rights of different accounts under different blocks. And that's exactly what feeds into the governor's voting section.
 */
contract DaoToken is PublicAccessUtils, ERC20Votes {

    bytes32 internal constant TOKEN_MANAGER = keccak256("TOKEN_MANAGER");
    bytes32 internal constant PROPOSAL_MANAGER = keccak256("PROPOSAL_MANAGER");
    
    constructor(address daoAccessControlAddress, string memory daoTokenName, string memory daoTokenSymbol) 
        ERC20(daoTokenName, daoTokenSymbol) ERC20Permit(daoTokenName) 
    {
        _initializeAccessControl(daoAccessControlAddress);
    }

    /**
     * @dev Query the current total supply of tokens.
     */
    function totalSupply() 
        public view override allowPermission(STAFF) returns (uint256) 
    {
        return super.totalSupply();
    }

    /**
     * @dev Check the current balance of an account.
     */
    function balanceOf(address account) 
        public view override allowPermission(TOKEN_MANAGER) returns (uint256) 
    {
        return super.balanceOf(account);
    }

    /**
     * @dev Transfer a specified amount of tokens from our own account to an account. 
     *
     * @notice This function is native to the ERC20 contract and can be used in a wide variety of scenarios. But for our business needs, it might not be a good idea for employees to be able to transfer their tokens around at will. Because our token exists more as a weight, which can be viewed as equity, or voting rights. So for now, we rewrite the function to be overridden by a permanent error.
     */
    function transfer(address to, uint256 amount) 
        public override allowPermission(STAFF) returns (bool) 
    {
        require(false, "The function is not avaliable.");
        return super.transfer(to, amount);
    }

    function transfer(address owner, address to, uint256 amount) 
        public allowPermission(TOKEN_MANAGER)
    {
        return super._transfer(owner, to, amount);
    }

    /**
     * @dev Authorizes an account to transfer its own tokens. 
     *
     * @notice Since it is not a good option to transfer tokens ourselves, it is also not a good option to authorize someone else to transfer tokens.
     */
    function allowance(address owner, address spender) 
        public view override allowPermission(STAFF) returns (uint256) 
    {
        require(false, "The function is not avaliable.");
        return super.allowance(owner, spender);
    }

    /**
     * @dev Authorizes an account to transfer the amount on the account. 
     *
     * @notice This is the same problem, so we locked this function.
     */
    function approve(address spender, uint256 amount) 
        public override allowPermission(STAFF) returns (bool) 
    {
        require(false, "The function is not avaliable.");
        return super.approve(spender, amount);
    }

    /**
     * @dev The manager can use this function to allocate tokens among employees.
     */
    function transferFrom(address from, address to, uint256 amount) 
        public override allowPermission(TOKEN_MANAGER) returns (bool) 
    {
        super._transfer(from, to, amount);
        return true;
    }

    /**
     * @dev The name of the token can be queried.
     */
    function name() 
        public view override allowPermission(MEMBER) returns (string memory) 
    {
        return super.name();
    }

    /**
     * @dev The symbol of the token can be queried.
     */
    function symbol() 
        public view override allowPermission(MEMBER) returns (string memory) 
    {
        return super.symbol();
    }

    /**
     * @dev The decimal place of the token can be queried.
     */
    function decimals() 
        public view override allowPermission(MEMBER) returns (uint8) 
    {
        return super.decimals();
    }

    /**
     * @dev We can use this function to get the voting power of an account. 
     * This is the function the proposal contract calls to get its data.
     */
    function getVotes(address account) 
        public view override allowPermission(PROPOSAL_MANAGER) returns (uint256) 
    {
        return super.getVotes(account);
    }

    /**
     * @dev Given a block number, we can get the voting power of an account in that block.
     */
    function getPastVotes(address account, uint256 blockNumber) 
        public view override allowPermission(PROPOSAL_MANAGER) returns (uint256) 
    {
        return super.getPastVotes(account, blockNumber);
    }

    /**
     * @dev Get the total token supply in a block number.
     */
    function getPastTotalSupply(uint256 blockNumber) 
        public view override allowPermission(PROPOSAL_MANAGER) returns (uint256)
    {
        return super.getPastTotalSupply(blockNumber);
    }

    /**
     * @dev Query the delegator address for an account
     */
    function delegates(address account) 
        public view override allowPermission(STAFF) returns (address) 
    {
        return super.delegates(account);
    }

    /**
     * @dev Set the delegator for our own account. 
     *
     * @notice Because this behavior can also cause undesired things, it is currently disabled as well. A delegator means that someone can own another person's vote and vote on his behalf.
     */
    function delegate(address delegatee) 
        public override allowPermission(STAFF)
    {
        require(false, "The function is not avaliable.");
        return super.delegate(delegatee);
    }

    /**
     * @dev allow manager manages staff's delegatees.
     *
     * The manager can use this function to set the user delegator. In most cases, the delegator will be the user themself. 
     *
     * @notice ERC20Votes will not start recording messages until the delegator is set, and the user can vote only after the delegator is set.
     */
    function delegateFrom(address delegator, address delegatee) 
        public allowPermission(TOKEN_MANAGER)
    {
        return super._delegate(delegator, delegatee);
    }

    /**
     * @dev This function grants the delegator by signing it. 
     *
     * @notice Same as the delegate function, so it's also disabled.
     */
    function delegateBySig(
        address delegatee,
        uint256 nonce,
        uint256 expiry,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public override allowPermission(STAFF) {
        require(false, "The function is not avaliable.");
        return super.delegateBySig(delegatee, nonce, expiry, v, r, s);
    }

    /**
     * @dev Authorize someone to move their balance. It also includes the maximum number of moves that can be made, as well as the expiration time of such authorization. 
     *
     * @notice Currently this function is not available in our business scenario either.
     */
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public override allowPermission(STAFF) {
        require(false, "The function is not avaliable.");
        return super.permit(owner, spender, value, deadline, v, r, s);
    }

    /**
     * @dev  This function returns the current nonce.
     */
    function nonces(address owner) 
        public view override allowPermission(STAFF) returns (uint256)
    {
        return super.nonces(owner);
    }

    /**
     * @dev Increase the amount of balance that someone can use. 
     *
     * @notice Currently not available.
     */
    function increaseAllowance(address spender, uint256 addedValue) 
        public override allowPermission(STAFF) returns (bool) 
    {
        require(false, "The function is not avaliable.");
        return super.increaseAllowance(spender, addedValue);
    }

    /**
     * @dev Reduce the amount of balance that someone can use. 
     *
     * @notice Currently not available.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) 
        public override allowPermission(STAFF) returns (bool) 
    {
        require(false, "The function is not avaliable.");
        return super.decreaseAllowance(spender, subtractedValue);
    }

    /**
     * @dev Mint some tokens for an account.
     */
    function mint(address account, uint256 amount) 
        public allowPermission(TOKEN_MANAGER) 
    {
        _mint(account, amount);
    }

    /**
     * @dev Destroy some tokens for an account.
     */
    function burn(address account, uint256 amount) 
        public allowPermission(TOKEN_MANAGER) 
    {
        _burn(account, amount);
    }

}