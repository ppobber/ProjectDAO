// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../PublicAccessUtils.sol";
import "../PublicProposalRecord.sol";

/**
 * @dev See {PublicProposalRecord}.
 */
contract ProjectProposalRecord is PublicAccessUtils, PublicProposalRecord {

   constructor (
        address projectAccessControlAddress, 
        address projectProposalAddress,
        address projectRecordAddress,
        address projectTokenAddress) 
        PublicProposalRecord(
            projectAccessControlAddress, 
            projectProposalAddress, 
            projectRecordAddress, 
            projectTokenAddress) {
        _initializeAccessControl(projectAccessControlAddress);
    }

    /**
     * @dev See {PublicProposalRecord-_createProposal}.
     */
    function createProposal(string memory description) 
        public allowPermissions(STAFF, STAFF) returns (uint16) 
    {
        return super._createProposal(description);
    }
    
    /**
     * @dev See {PublicProposalRecord-_addBehavior}.
     */
    function addBehavior(
        uint16 proposalNumber,
        address target, 
        uint256 value, 
        bytes memory operation) 
        public allowPermissions(PROPOSAL_MANAGER, ADMIN)
    {
        super._addBehavior(proposalNumber, target, value, operation);
    }

    /**
     * @dev See {PublicProposalRecord-_addRecordBehavior}.
     */
    function addRecordBehavior(
        uint16 proposalNumber, 
        string memory infomation) 
        public allowPermissions(STAFF, STAFF)
    {
        super._addRecordBehavior(proposalNumber, infomation);
    }

    /**
     * @dev See {PublicProposalRecord-_addTransferEthBehavior}.
     */
    function addTransferEthBehavior(
        uint16 proposalNumber, 
        address receiveAddress, 
        uint256 transferValue) 
        public payable allowPermissions(STAFF, STAFF)
    {
        super._addTransferEthBehavior(proposalNumber, receiveAddress, transferValue);
    }

    /**
     * @dev See {PublicProposalRecord-_addMintTokenBehavior}.
     */
    function addMintTokenBehavior(
        uint16 proposalNumber, 
        address mintAddress,
        uint256 mintNumber) 
        public allowPermissions(STAFF, STAFF)
    {
        super._addMintTokenBehavior(proposalNumber,mintAddress, mintNumber);
    }

    /**
     * @dev See {PublicProposalRecord-_releaseProposal}.
     */
    function releaseProposal(uint16 proposalNumber) 
        public allowPermissions(PROPOSAL_MANAGER, ADMIN) returns (bool) 
    {
        return super._releaseProposal(proposalNumber);
    }

    /**
     * @dev See {PublicProposalRecord-_releaseProposalWithSetting}.
     */
    function releaseProposalWithSetting(
        uint16 proposalNumber,
        uint256 newVotingDelay, 
        uint256 newVotingPeriod, 
        uint256 newProposalThreshold,
        uint256 newQuormNumber) 
        public allowPermissions(PROPOSAL_MANAGER, ADMIN) returns (bool) 
    {
        return super._releaseProposalWithSetting(proposalNumber, newVotingDelay, newVotingPeriod, newProposalThreshold, newQuormNumber);
    }

    /**
     * @dev See {PublicProposalRecord-_inquiryLatestProposalNumber}.
     */
    function inquiryLatestProposalNumber() 
        public view  allowPermissions(STAFF, STAFF) returns (uint16) 
    {
        return super._inquiryLatestProposalNumber();
    }

    /**
     * @dev See {PublicProposalRecord-_inquiryProposalState}.
     */
    function inquiryProposalState(uint16 proposalNumber) 
        public view allowPermissions(STAFF, STAFF) returns (string memory) 
    {
        return super._inquiryProposalState(proposalNumber);
    }

    /**
     * @dev See {PublicProposalRecord-_inquiryProposalInformation}.
     */
    function inquiryProposalInformation(uint16 proposalNumber)
        public view allowPermissions(STAFF, STAFF) returns (ProposalInformation memory) 
    {
        return super._inquiryProposalInformation(proposalNumber);
    }

    /**
     * @dev See {PublicProposalRecord-_inquiryProposalId}.
     */
    function inquiryProposalId(uint16 proposalNumber)
        public view allowPermissions(STAFF, STAFF) returns (uint256) 
    {
        return super._inquiryProposalId(proposalNumber);
    }

    /**
     * @dev See {PublicProposalRecord-_executeProposal}.
     */
    function executeProposal(uint16 proposalNumber) 
        public allowPermissions(PROPOSAL_MANAGER, ADMIN) returns (bool) 
    {
        return super._executeProposal(proposalNumber);
    }

    /**
     * @dev See {PublicProposalRecord-_cancelProposal}.
     */
    function cancelProposal(uint16 proposalNumber) 
        public allowPermissions(PROPOSAL_MANAGER, ADMIN) returns (bool) 
    {
        return super._cancelProposal(proposalNumber);
    }

}