// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../PublicAccessUtils.sol";

/**
 * @dev The contract records the important information of the project.
 *
 * The project record contract uses mutable function permissions to give all stored data greater permission freedom. In the project record contract, we mainly used different arrays to store different project information according to all the requirements of PM team for the project. 
 * And each piece of information has a special write function and a query function. The write function requires the permission of the manager, while the query function only requires the permission of the staff.
 */
contract ProjectRecord is PublicAccessUtils {

    bytes32 internal constant RECORD_MANAGER = keccak256("RECORD_MANAGER");

    bytes32 private constant _riskLevelLow = keccak256(abi.encode("low"));
    bytes32 private constant _riskLevelModerate = keccak256(abi.encode("moderate"));
    bytes32 private constant _riskLevelHigh = keccak256(abi.encode("high"));
    bytes32 private constant _riskLevelExtreme = keccak256(abi.encode("extreme"));

    event LowRisk(bytes32 lowRisk, address sender);
    event ModerateRisk(bytes32 moderateRisk, address sender);
    event HighRisk(bytes32 highRisk, address sender);
    event ExtremeRisk(bytes32 extremeRisk, address sender);

    event NpvRecorded(uint32 NpvRecord, address sender);

    event objectiveRecorded(string projectObjective, address sender);
    event BudgetRecorded(string projectBudget, address sender);
    event ScheduleRecorded(string projectSchedule, address sender);
    event ROIRecorded(string projectROI, address sender);
    event MgmtPlanRecorded(string projectMgmtPlan, address sender);
    event RiskPlanRecorded(string projectRiskPlan, address sender);

    uint32[] private npvList;
    bytes32[] private riskList;

    string private _projectObjective = "";
    string private _projectBudget = "";
    string private _projectSchedule= "";
    string private _projectROI= "";
    string private _projectMgmtPlan= "";
    string private _projectRiskPlan= "";

    bytes32 internal constant FUNC_recordNPV = keccak256(
        "function recordNPV(uint32)");
    bytes32 internal constant FUNC_getNPV = keccak256(
        "function getNPV()");

    bytes32 internal constant FUNC_recordRisk = keccak256(
        "function recordRisk(string)");
    bytes32 internal constant FUNC_getRisk = keccak256(
        "function getRisk(string)");

    bytes32 internal constant FUNC_setProjectObjective = keccak256(
        "function setProjectObjective(string)");
    bytes32 internal constant FUNC_getProjectObjective = keccak256(
        "function getProjectObjective()");

    bytes32 internal constant FUNC_setProjectBudget = keccak256(
        "function setProjectBudget(string)");
    bytes32 internal constant FUNC_getProjectBudget = keccak256(
        "function getProjectBudget()");

    bytes32 internal constant FUNC_setProjectSchedule = keccak256(
        "function setProjectSchedule(string)");
    bytes32 internal constant FUNC_getProjectSchedule = keccak256(
        "function getProjectSchedule()");

    bytes32 internal constant FUNC_setProjectROI = keccak256(
        "function setProjectROI(string)");
    bytes32 internal constant FUNC_getProjectROI = keccak256(
        "function getProjectROI()");

    bytes32 internal constant FUNC_setProjectMgmtPlan = keccak256(
        "function setProjectMgmtPlan(string)");
    bytes32 internal constant FUNC_getProjectMgmtPlan = keccak256(
        "function getProjectMgmtPlan()");

    bytes32 internal constant FUNC_setProjectRiskPlan = keccak256(
        "function setProjectRiskPlan(string)");
    bytes32 internal constant FUNC_getProjectRiskPlan = keccak256(
        "function getProjectRiskPlan()");
    

    constructor(address projectAccessControlAddress) {
        _initializeAccessControl(projectAccessControlAddress);
        _initializeFunctionPermission(FUNC_recordNPV, RECORD_MANAGER);
        _initializeFunctionPermission(FUNC_getNPV, STAFF);
        _initializeFunctionPermission(FUNC_recordRisk, RECORD_MANAGER);
        _initializeFunctionPermission(FUNC_getRisk, STAFF);
        _initializeFunctionPermission(FUNC_setProjectObjective, RECORD_MANAGER);
        _initializeFunctionPermission(FUNC_getProjectObjective, STAFF);
        _initializeFunctionPermission(FUNC_setProjectBudget, RECORD_MANAGER);
        _initializeFunctionPermission(FUNC_getProjectBudget, STAFF);
        _initializeFunctionPermission(FUNC_setProjectSchedule, RECORD_MANAGER);
        _initializeFunctionPermission(FUNC_getProjectSchedule, STAFF);
        _initializeFunctionPermission(FUNC_setProjectROI, RECORD_MANAGER);
        _initializeFunctionPermission(FUNC_getProjectROI, STAFF);
        _initializeFunctionPermission(FUNC_setProjectMgmtPlan, RECORD_MANAGER);
        _initializeFunctionPermission(FUNC_getProjectMgmtPlan, STAFF);
        _initializeFunctionPermission(FUNC_setProjectRiskPlan, RECORD_MANAGER);
        _initializeFunctionPermission(FUNC_getProjectRiskPlan, STAFF);
    }

    function modifyPermission(bytes32 functionBytes, bytes32 permission) 
        public allowPermission(ADMIN) 
    {
        _modifyFunctionPermission(functionBytes, permission);
    }

    /**
     * @dev NPV is a very important part of a project, and it needs to be recorded and updated frequently. * 
     * NPV is stored as an array unlike other records, which means that we can view all historical NPV states on the blockchain.
     */
    function recordNPV(uint32 npvNow) 
        public allowPermissions(_getFunctionPermission(FUNC_recordNPV), ADMIN) 
    {
        npvList.push(npvNow);
        emit NpvRecorded(npvNow, msg.sender);
    }

    /**
     * @dev Query the NPV content of all records.
     */
    function getNPV() 
        public view allowPermissions(_getFunctionPermission(FUNC_getNPV), STAFF) returns(uint32[] memory) 
    {
        return npvList;
    }

    /**
     * @dev Record the risk status.
     *
     * We have stipulated that there are several different levels of risk, so the content of the record must be carried out according to the stipulation, otherwise the record will not be successful.
     */
    function recordRisk(string memory riskLevel) 
        public allowPermissions(_getFunctionPermission(FUNC_recordRisk), ADMIN) 
    {
        bytes32 userRiskLevel = keccak256(abi.encode(riskLevel));
        if (userRiskLevel == _riskLevelLow) {
            riskList.push(_riskLevelLow);
            emit LowRisk(_riskLevelLow, msg.sender);
        }
        else if (userRiskLevel == _riskLevelModerate) {
            riskList.push(_riskLevelModerate);
            emit ModerateRisk(_riskLevelModerate, msg.sender);
        }
        else if (userRiskLevel == _riskLevelHigh) {
            riskList.push(_riskLevelHigh);
            emit HighRisk(_riskLevelHigh, msg.sender);
        }
        else if (userRiskLevel == _riskLevelExtreme) {
            riskList.push(_riskLevelExtreme);
            emit ExtremeRisk(_riskLevelExtreme, msg.sender);
        }
        else {
            revert("Record: input wrong.");
        }
    }

    /**
     * @dev Get the current risk status.
     */
    function getRisk() 
        public view allowPermissions(_getFunctionPermission(FUNC_getRisk), STAFF) returns(bytes32[] memory) 
    {
        return riskList;
    }

    /**
     * @dev Set the goal for the project.
     */
    function setProjectObjective(string memory projectObjective) 
        public allowPermissions(_getFunctionPermission(FUNC_setProjectObjective), ADMIN)
    {
        _projectObjective = projectObjective;
        emit objectiveRecorded(_projectObjective, msg.sender);
    }

    /**
     * @dev Get the goal of the project.
     */
    function getProjectObjective() 
        public view allowPermissions(_getFunctionPermission(FUNC_getProjectObjective), STAFF) returns(string memory) 
    {
        return _projectObjective;
    }

    /**
     * @dev Set the budget for the project.
     */
    function setProjectBudget(string memory projectBudget) 
        public allowPermissions(_getFunctionPermission(FUNC_setProjectBudget), ADMIN)
    {
        _projectBudget = projectBudget;
        emit BudgetRecorded(_projectBudget, msg.sender);
    }

    /**
     * @dev Get the budget for the project.
     */
    function getProjectBudget() 
        public view allowPermissions(_getFunctionPermission(FUNC_getProjectBudget), STAFF) returns(string memory)
    {
        return _projectBudget;
    }

    /**
     * @dev Sets the schedule for the project. This information helps keep the progress of the project under control.
     */
    function setProjectSchedule(string memory projectSchedule) 
        public allowPermissions(_getFunctionPermission(FUNC_setProjectSchedule), ADMIN)
    {
        _projectSchedule = projectSchedule;
        emit ScheduleRecorded(_projectSchedule, msg.sender);
    }

    /**
     * @dev Gets the schedule for the project.
     */
    function getProjectSchedule() 
        public view allowPermissions(_getFunctionPermission(FUNC_getProjectSchedule), STAFF) returns(string memory) 
    {
        return _projectSchedule;
    }

    /**
     * @dev Set the ROI for the project.
     */
    function setProjectROI(string memory projectROI) 
        public allowPermissions(_getFunctionPermission(FUNC_setProjectROI), ADMIN)
    {
        _projectROI = projectROI;
        emit ROIRecorded(_projectROI, msg.sender);
    }

    /**
     * @dev Get the ROI for the project.
     */
    function getProjectROI() 
        public view allowPermissions(_getFunctionPermission(FUNC_getProjectROI), STAFF) returns(string memory) 
    {
        return _projectROI;
    }

    /**
     * @dev Set the management plan for the project.
     */
    function setProjectMgmtPlan(string memory projectMgmtPlan) 
        public allowPermissions(_getFunctionPermission(FUNC_setProjectMgmtPlan), ADMIN)
    {
        _projectMgmtPlan = projectMgmtPlan;
        emit MgmtPlanRecorded(_projectMgmtPlan, msg.sender);
    }

    /**
     * @dev Get the management plan for the project.
     */
    function getProjectMgmtPlan() 
        public view allowPermissions(_getFunctionPermission(FUNC_getProjectMgmtPlan), STAFF) returns(string memory) 
    {
        return _projectMgmtPlan;
    }

    /**
     * @dev Set the risk plan for the project.
     */
    function setProjectRiskPlan(string memory projectRiskPlan) 
        public allowPermissions(_getFunctionPermission(FUNC_setProjectRiskPlan), ADMIN)
    {
        _projectRiskPlan = projectRiskPlan;
        emit RiskPlanRecorded(_projectRiskPlan, msg.sender);
    }

    /**
     * @dev Get the risk plan for the project.
     */
    function getProjectRiskPlan() 
        public view allowPermissions(_getFunctionPermission(FUNC_getProjectRiskPlan), STAFF) returns(string memory) 
    {
        return _projectRiskPlan;
    }

}