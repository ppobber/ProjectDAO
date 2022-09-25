// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface IDaoAccessControlInherit{

    

    //check if the role contains the address, only organizational contracts can inqiury
    function inquiryAddressPermission(bytes32 permission,address account) 
        external 
        view 
        returns(bool);


}