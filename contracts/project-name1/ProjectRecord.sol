// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// import "../IAccessControl.sol";
import "../PublicAccessUtils.sol";

contract ProjectRecord is PublicAccessUtils {

    bytes32 private constant _riskLevelLow = keccak256(abi.encode("low"));
    bytes32 private constant _riskLevelModerate = keccak256(abi.encode("moderate"));
    bytes32 private constant _riskLevelHigh = keccak256(abi.encode("high"));
    bytes32 private constant _riskLevelExtreme = keccak256(abi.encode("extreme"));

    event LowRisk(bytes32 indexed lowRisk, address indexed sender);
    event ModerateRisk(bytes32 indexed moderateRisk, address indexed sender);
    event HighRisk(bytes32 indexed highRisk, address indexed sender);
    event ExtremeRisk(bytes32 indexed extremeRisk, address indexed sender);

    event NpvRecorded(uint32 indexed NpvRecord, address indexed sender);

    event objectiveRecorded(string indexed projectObjective, address indexed sender);
    event BudgetRecorded(string indexed projectBudget, address indexed sender);
    event ScheduleRecorded(string indexed projectSchedule, address indexed sender);
    event ROIRecorded(string indexed projectROI, address indexed sender);
    event MgmtPlanRecorded(string indexed projectMgmtPlan, address indexed sender);
    event RiskPlanRecorded(string indexed projectRiskPlan, address indexed sender);

    uint32[] private npvList;
    bytes32[] private riskList;

    string private _projectObjective = "";
    string private _projectBudget = "";
    string private _projectSchedule= "";
    string private _projectROI= "";
    string private _projectMgmtPlan= "";
    string private _projectRiskPlan= "";

    bytes32 internal constant FUNC_recordNPV = keccak256(
        "function recordNPV(uint32 npvNow)");
    bytes32 internal constant FUNC_getNPV = keccak256(
        "function getNPV()");

    bytes32 internal constant FUNC_recordRisk = keccak256(
        "function recordRisk(string memory riskLevel)");
    bytes32 internal constant FUNC_getRisk = keccak256(
        "function getRisk(string memory riskLevel)");

    bytes32 internal constant FUNC_setProjectObjective = keccak256(
        "function setProjectObjective(string memory _projectObjective)");
    bytes32 internal constant FUNC_getProjectObjective = keccak256(
        "function getProjectObjective()");

    bytes32 internal constant FUNC_setProjectBudget = keccak256(
        "function setProjectBudget(string memory _projectBudget)");
    bytes32 internal constant FUNC_getProjectBudget = keccak256(
        "function getProjectBudget()");

    bytes32 internal constant FUNC_setProjectSchedule = keccak256(
        "function setProjectSchedule(string memory _projectSchedule)");
    bytes32 internal constant FUNC_getProjectSchedule = keccak256(
        "function getProjectSchedule()");

    bytes32 internal constant FUNC_setProjectROI = keccak256(
        "function setProjectROI(string memory _projectROI)");
    bytes32 internal constant FUNC_getProjectROI = keccak256(
        "function getProjectROI()");

    bytes32 internal constant FUNC_setProjectMgmtPlan = keccak256(
        "function setProjectMgmtPlan(string memory_projectMgmtPlan)");
    bytes32 internal constant FUNC_getProjectMgmtPlan = keccak256(
        "function getProjectMgmtPlan()");

    bytes32 internal constant FUNC_setProjectRiskPlan = keccak256(
        "function setProjectRiskPlan(string memory_projectRiskPlan)");
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

    function recordNPV(uint32 npvNow) 
        public allowPermissions(_getFunctionPermission(FUNC_recordNPV), ADMIN) 
    {
        npvList.push(npvNow);
        emit NpvRecorded(npvNow, msg.sender);
    }

    function getNPV() 
        public view returns(uint32[] memory) 
    {
        return npvList;
    }

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

    function getRisk() 
        public view returns(bytes32[] memory) 
    {
        return riskList;
    }

    function setProjectObjective(string memory projectObjective) 
        public allowPermissions(_getFunctionPermission(FUNC_setProjectObjective), ADMIN)
    {
        _projectObjective = projectObjective;
        emit objectiveRecorded(_projectObjective, msg.sender);
    }

    function getProjectObjective() 
        public view returns(string memory) 
    {
        return _projectObjective;
    }

    function setProjectBudget(string memory projectBudget) 
        public allowPermissions(_getFunctionPermission(FUNC_setProjectBudget), ADMIN)
    {
        _projectBudget = projectBudget;
        emit BudgetRecorded(_projectBudget, msg.sender);
    }

    function getProjectBudget() 
        public view returns(string memory)
    {
        return _projectBudget;
    }

    function setProjectSchedule(string memory projectSchedule) 
        public allowPermissions(_getFunctionPermission(FUNC_setProjectSchedule), ADMIN)
    {
        _projectSchedule = projectSchedule;
        emit ScheduleRecorded(_projectSchedule, msg.sender);
    }

    function getProjectSchedule() 
        public view returns(string memory) 
    {
        return _projectSchedule;
    }

    function setProjectROI(string memory projectROI) 
        public allowPermissions(_getFunctionPermission(FUNC_setProjectROI), ADMIN)
    {
        _projectROI = projectROI;
        emit ROIRecorded(_projectROI, msg.sender);
    }

    function getProjectROI() 
        public view returns(string memory) 
    {
        return _projectROI;
    }

    function setProjectMgmtPlan(string memory projectMgmtPlan) 
        public allowPermissions(_getFunctionPermission(FUNC_setProjectMgmtPlan), ADMIN)
    {
        _projectMgmtPlan = projectMgmtPlan;
        emit MgmtPlanRecorded(_projectMgmtPlan, msg.sender);
    }

    function getProjectMgmtPlan() 
        public view returns(string memory) 
    {
        return _projectMgmtPlan;
    }

    function setProjectRiskPlan(string memory projectRiskPlan) 
        public allowPermissions(_getFunctionPermission(FUNC_setProjectRiskPlan), ADMIN)
    {
        _projectRiskPlan = projectRiskPlan;
        emit RiskPlanRecorded(_projectRiskPlan, msg.sender);
    }

    function getProjectRiskPlan() 
        public view returns(string memory) 
    {
        return _projectRiskPlan;
    }

}