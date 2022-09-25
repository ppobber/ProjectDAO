// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";

import "./DaoAccessControl.sol";

contract DaoToken is ERC20, ERC20Burnable, ERC20Permit, ERC20Votes{
    
    string internal constant TokenName = "";
    string internal constant TokenSymbol = "";



    constructor() ERC20(TokenName, TokenSymbol) ERC20Permit(TokenName) {
        _mint(msg.sender, 100 * 10 ** decimals());
    }


    function mint(address to, uint256 amount) public {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender),"Only admin can mint");

        
        _mint(to, amount);
    }


}