// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// import "../project/ProjectAccessControl.sol";
// import "../project/ProjectRecord.sol";
// import "../project/ProjectToken.sol";
import "../project/ProjectProposal.sol";
// import "../project/ProjectProposalRecord.sol";

import "@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";

import "../PublicAccessUtils.sol";

/**
 * 
 */
contract DaoProjectCreate is PublicAccessUtils {

    address internal _daoAccessControlAddress;

    // ProjectAccessControl internal _projectAccessControl;
    // ProjectRecord internal _projectRecord;
    // ProjectToken internal _projectToken;
    // ProjectProposal internal _projectProposal;
    // ProjectProposalRecord internal _projectProposalRecord;

    // address public _projectAccessControlAddress;
    // address public _projectRecordAddress;
    // address public _projectTokenAddress;
    // address public _projectProposalAddress;
    // address public _projectProposalRecordAddress;

    constructor(address daoAccessControlAddress) {
        _initializeAccessControl(daoAccessControlAddress);
        _daoAccessControlAddress = daoAccessControlAddress;
    }

    function createProject(
        // string memory projectName,
        // string memory projectAdminName, 
        // string memory projectAdminEmail,
        // string memory projectTokenName, 
        // string memory projectTokenSymbol
    ) public allowPermission(ADMIN)
        returns(
            address _projectAccessControlAddress,
            // address _projectRecordAddress,
            address _projectTokenAddress,
            address _projectProposalAddress
            // address _projectProposalRecordAddress
        ) 
    {
        // _projectAccessControlAddress = _createProjectAccessControl(projectName, projectAdminName, projectAdminEmail);
        // _projectRecordAddress = _createProjectRecord(_projectAccessControlAddress);
        // _projectTokenAddress = _createProjectToken(_projectAccessControlAddress, projectTokenName, projectTokenSymbol);
        _projectProposalAddress = _createProjectProposal(_projectAccessControlAddress, _projectTokenAddress);
        // _projectProposalRecordAddress = _createProjectProposalRecord(_projectAccessControlAddress, _projectProposalAddress, _projectRecordAddress, _projectTokenAddress);
    }

    // function _createProjectAccessControl(
    //     string memory projectName,
    //     string memory projectAdminName, 
    //     string memory projectAdminEmail) private returns(address) 
    // {
    //     ProjectAccessControl _projectAccessControl = new ProjectAccessControl(_daoAccessControlAddress, projectName, projectAdminName, projectAdminEmail);
    //     return address(_projectAccessControl);
    // }

    // function _createProjectRecord(address projectAccessControlAddress) 
    //     private returns(address) 
    // {
    //     ProjectRecord _projectRecord = new ProjectRecord(projectAccessControlAddress);
    //     return address(_projectRecord);
    // }

    // function _createProjectToken(
    //     address projectAccessControlAddress,
    //     string memory projectTokenName, 
    //     string memory projectTokenSymbol) private returns(address) 
    // {
    //     ProjectToken _projectToken = new ProjectToken(projectAccessControlAddress, projectTokenName, projectTokenSymbol);
    //     return address(_projectToken);
    // }

    function _createProjectProposal(
        address projectAccessControlAddress, 
        address projectTokenAddress) private returns(address) 
    {
        IVotes projectToken = IVotes(projectTokenAddress);
        ProjectProposal _projectProposal = new ProjectProposal(projectAccessControlAddress, "", projectToken, 0, 10, 0, 0);
        return address(_projectProposal);
    }

    // function _createProjectProposalRecord(
    //     address projectAccessControlAddress, 
    //     address projectProposalAddress,
    //     address projectRecordAddress,
    //     address projectTokenAddress) private returns(address) 
    // {
    //     ProjectProposalRecord _projectProposalRecord = new ProjectProposalRecord(projectAccessControlAddress, projectProposalAddress, projectRecordAddress, projectTokenAddress);
    //     return address(_projectProposalRecord);
    // }

}