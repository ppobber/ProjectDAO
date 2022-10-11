// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// import "../IAccessControl.sol";
import "../AccessUtils.sol";

contract DaoRecord is AccessUtils {

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

    bytes32 internal constant STAFF_ROLE = keccak256("STAFF");
    bytes32 internal constant RECORD_MANAGER_ROLE = keccak256("RECORD_MANAGER");

    constructor(address daoAccessControlAddress) {
        initializeAccessControl(daoAccessControlAddress);
    }

    function recordNPV(uint32 npvNow) public allowPermission(STAFF) {
        //todo
        npvList.push(npvNow);
        emit NpvRecordSuccess("Record Success.");
    }

    function test() public returns (address) {
        return getAdmin();
    }

    function test1() public returns (bool) {
        return check(STAFF, msg.sender);
    }

    function inquiryNPV() public view allowPermission(STAFF) returns(uint32[] memory) {
        return npvList;
    }

    function recordRisk(string memory riskLevel) public allowPermission(STAFF) {
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
}