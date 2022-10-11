// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";

import "../AccessUtils.sol";

contract DaoToken is AccessUtils, ERC20, ERC20Burnable, ERC20Permit, ERC20Votes {
    
    string internal constant TokenName = "DAOTOKEN";
    string internal constant TokenSymbol = "DTK";



    constructor(address daoAccessControlAddress) ERC20(TokenName, TokenSymbol) ERC20Permit(TokenName) {
        initializeAccessControl(daoAccessControlAddress);
        _mint(getAdmin(), 100 * 10 ** decimals());
    }


    function mint(address to, uint256 amount) public allowPermission(TOKEN_MANAGER) {
        _mint(to, amount);
    }

// The following functions are overrides required by Solidity.

    function _afterTokenTransfer(address from, address to, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._afterTokenTransfer(from, to, amount);
    }

    function _mint(address to, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._mint(to, amount);
    }

    function _burn(address account, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._burn(account, amount);
    }



}