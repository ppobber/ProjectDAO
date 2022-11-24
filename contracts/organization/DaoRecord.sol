// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../PublicAccessUtils.sol";

/**
 * @dev In an organization's record contract, it is mainly used to record the necessary information of the organization. So we provide an array of information. There is also a function for modifying and a function for querying.
 *
 * In this contract, we use the incidental functionality in the public access control utilities contract. We can see that during the initialization process, we introduced the organizational access control contract, a step that is necessary for other contracts. But we also did a series of actions to initialize function permissions. We give each of the different functions different permissions. We can flexibly change the permissions of each function in the subsequent use of the function.
 */
contract DaoRecord is PublicAccessUtils {

    bytes32 internal constant RECORD_MANAGER = keccak256("RECORD_MANAGER");

    string[] private informationList;
    string[] private projectNameList;

    event informationRecorded(address sender, string information);

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

    /**
     * @dev Permission to modify other functions in this contract.
     */
    function modifyPermission(bytes32 functionBytes, bytes32 permission) 
        public allowPermission(ADMIN) 
    {
        _modifyFunctionPermission(functionBytes, permission);
    }

    /**
     * @dev Used to record some text information.
     */
    function recordInformation(string memory information) 
        public allowPermission(_getFunctionPermission(FUNC_recordInformation)) 
    {
        informationList.push(information);
        emit informationRecorded(msg.sender, information);
    }

    /**
     * @dev Queries information about all records.
     */
    function inquiryInformation() 
        public view allowPermission(_getFunctionPermission(FUNC_inquiryInformation)) returns(string[] memory) 
    {
        return informationList;
    }

    /**
     * @dev Records the names of all items in the organization. Whenever a new project is voted on, the proposal contract automatically calls this function to write the project name.
     */
    function recordProjectName(string memory projectName)
        public allowPermission(_getFunctionPermission(FUNC_recordProjectName)) 
    {
        projectNameList.push(projectName);
        emit informationRecorded(msg.sender, projectName);
    }

    /**
     * @dev Queries all project names in the organization.
     */
    function inquiryProjectName()
        public view allowPermission(_getFunctionPermission(FUNC_inquiryProjectName)) 
        returns(string[] memory) 
    {
        return projectNameList;
    }

}