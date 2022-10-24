// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../PublicAccessUtils.sol";

contract DaoRecord is PublicAccessUtils {

    string[] private informationList;

    event informationRecorded(address indexed sender, string indexed information);

    bytes32 internal constant RECORD_MANAGER = keccak256("RECORD_MANAGER");

    bytes32 internal constant FUNC_recordInformation = keccak256("function recordInformation(string memory information)");
    bytes32 internal constant FUNC_inquiryInformation = keccak256("function inquiryInformation()");

    constructor(address daoAccessControlAddress) {
        _initializeAccessControl(daoAccessControlAddress);
        _initializeFunctionPermission(FUNC_recordInformation, RECORD_MANAGER);
        _initializeFunctionPermission(FUNC_inquiryInformation, STAFF);
        //...should initialize all functions permission at the first time
    }

    function modifyPermission(bytes32 functionBytes, bytes32 permission) 
        public allowPermission(ADMIN) 
    {
        _modifyFunctionPermission(functionBytes, permission);
    }

    function recordInformation(string memory information) 
        public allowPermission(_getFunctionPermission(FUNC_recordInformation)) 
    {
        informationList.push(information);
        emit informationRecorded(msg.sender, information);
    }

    function inquiryInformation() 
        public allowPermission(_getFunctionPermission(FUNC_inquiryInformation)) returns(string[] memory) 
    {
        return informationList;
    }

    function inquiryTest() 
        public view allowPermission(STAFF) returns(string memory) 
    {
        return "Call Success";
    }


}