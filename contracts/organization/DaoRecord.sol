// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../PublicAccessUtils.sol";

contract DaoRecord is PublicAccessUtils {

    bytes32 internal constant RECORD_MANAGER = keccak256("RECORD_MANAGER");

    string[] private informationList;
    string[] private projectNameList;

    event informationRecorded(address indexed sender, string indexed information);

    bytes32 internal constant FUNC_recordInformation = keccak256("function recordInformation(string)");
    bytes32 internal constant FUNC_inquiryInformation = keccak256("function inquiryInformation()");
    bytes32 internal constant FUNC_recordProjectName = keccak256("function recordProjectName(string)");
    bytes32 internal constant FUNC_inquiryProjectName = keccak256("function inquiryProjectName()");

    constructor(address daoAccessControlAddress) {
        _initializeAccessControl(daoAccessControlAddress);
        _initializeFunctionPermission(FUNC_recordInformation, RECORD_MANAGER);
        _initializeFunctionPermission(FUNC_inquiryInformation, STAFF);
        _initializeFunctionPermission(FUNC_recordProjectName, RECORD_MANAGER);
        _initializeFunctionPermission(FUNC_inquiryProjectName, STAFF);
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
        public view allowPermission(_getFunctionPermission(FUNC_inquiryInformation)) returns(string[] memory) 
    {
        return informationList;
    }

    function recordProjectName(string memory projectName)
        public allowPermission(_getFunctionPermission(FUNC_recordProjectName)) 
    {
        projectNameList.push(projectName);
        emit informationRecorded(msg.sender, projectName);
    }

    function inquiryProjectName()
        public view allowPermission(_getFunctionPermission(FUNC_inquiryProjectName)) 
        returns(string[] memory) 
    {
        return projectNameList;
    }

}