// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// import "../IAccessControl.sol";
import "../AccessUtils.sol";

contract ProjectRecord  {

    bytes32 private constant riskLevelLow = keccak256(abi.encode("low"));
    bytes32 private constant riskLevelModerate = keccak256(abi.encode("moderate"));
    bytes32 private constant riskLevelHigh = keccak256(abi.encode("high"));
    bytes32 private constant riskLevelExtreme = keccak256(abi.encode("extreme"));

    event LowRisk(string indexed lowRiskOutput);
    event ModerateRisk(string indexed moderateRiskOutput);
    event HighRisk(string indexed highRiskOutput);
    event ExtremeRisk(string indexed extremeRiskOutput);

    event NpvRecordSuccess(string indexed NpvRecordSuccessOutput);

    uint32[] private npvList;

    bytes32 internal constant STAFF_ROLE = keccak256("STAFF_ROLE");
    bytes32 internal constant RECORD_MANAGER_ROLE = keccak256("RECORD_MANAGER_ROLE");

    string private projectObjective;
    string private projectBudget;
    string private projectSchedule;
    string private projectROI;
    string private projectMgmtPlan;
    string private projectRiskPlan;

    // constructor(address daoAccessControlAddress) {
    //     initializeAccessControl(daoAccessControlAddress);
    // }

    function recordNPV(uint32 npvNow) public {
        //todo
        npvList.push(npvNow);
        emit NpvRecordSuccess("Record Success.");
    }

    function inquiryNPV() public view returns(uint32[] memory) {
        return npvList;
    }

    function recordRisk(string memory riskLevel) public {
        bytes32 userRiskLevel = keccak256(abi.encode(riskLevel));
        if (userRiskLevel == riskLevelLow) {
            emit LowRisk("The risk level is low.");
        }
        else if (userRiskLevel == riskLevelModerate) {
            emit ModerateRisk("The risk level is moderate.");
        }
        else if (userRiskLevel == riskLevelHigh) {
            emit HighRisk("The risk level is high. Start checking procedure...");
        }
        else if (userRiskLevel == riskLevelExtreme) {
            emit ExtremeRisk("The risk level is extreme. Start checking procedure...");
        }
        else {
            revert("Record: input wrong.");
        }
    }

    function setProjectObjective(string memory _projectObjective) public {
        projectObjective = _projectObjective;
    }

    function getProjectObjective() public view returns(string memory) {
        return projectObjective;
    }

    function setProjectBudget(string memory _projectBudget) public {
        projectBudget = _projectBudget;
    }

    function getProjectBudget() public view returns(string memory) {
        return projectBudget;
    }

    function setProjectSchdule(string memory _projectSchdule) public {
        projectSchedule = _projectSchdule;
    }

    function getProjectSchdule() public view returns(string memory) {
        return projectSchedule;
    }

    function setProjectMgmtPlan(string memory _projectMgmtPlan) public {
        projectMgmtPlan = _projectMgmtPlan;
    }

    function getProjectMgmtPlan() public view returns(string memory) {
        return projectMgmtPlan;
    }

    function setProjectRiskPlan(string memory _projectRiskPlan) public {
        projectRiskPlan = _projectRiskPlan;
    }

    function getProjectRiskPlan() public view returns(string memory) {
        return projectRiskPlan;
    }

    function setProjectROI(string memory _projectROI) public {
        projectROI = _projectROI;
    }

    function getProjectROI() public view returns(string memory) {
        return projectROI;
    }
}