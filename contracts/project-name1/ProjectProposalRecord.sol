// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../PublicAccessUtils.sol";
import "../PublicProposalRecord.sol";

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

    function createProposal(string memory description) 
        public allowPermissions(STAFF, STAFF) returns (uint16) 
    {
        return super._createProposal(description);
    }
    
    function addBehaviour(
        uint16 proposalNumber,
        address target, 
        uint256 value, 
        bytes memory operation) 
        public allowPermissions(PROPOSAL_MANAGER, ADMIN)
    {
        super._addBehaviour(proposalNumber, target, value, operation);
    }

    function addRecordBehaviour(
        uint16 proposalNumber, 
        string memory infomation) 
        public allowPermissions(STAFF, STAFF)
    {
        super._addRecordBehaviour(proposalNumber, infomation);
    }

    //It will cause unexpected results. It's not good to transfer eth by contract.
    function addTransferEthBehaviour(
        uint16 proposalNumber, 
        address receiveAddress, 
        uint256 transferValue) 
        public payable allowPermissions(STAFF, STAFF)
    {
        super._addTransferEthBehaviour(proposalNumber, receiveAddress, transferValue);
    }

    function addMintTokenBehaviour(
        uint16 proposalNumber, 
        address mintAddress,
        uint256 mintNumber) 
        public allowPermissions(STAFF, STAFF)
    {
        super._addMintTokenBehaviour(proposalNumber,mintAddress, mintNumber);
    }

    function releaseProposal(uint16 proposalNumber) 
        public allowPermissions(PROPOSAL_MANAGER, ADMIN) returns (bool) 
    {
        return super._releaseProposal(proposalNumber);
    }

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

    function inquiryLatestProposalNumber() 
        public view  allowPermissions(STAFF, STAFF) returns (uint16) 
    {
        return super._inquiryLatestProposalNumber();
    }

    function inquiryProposalState(uint16 proposalNumber) 
        public view allowPermissions(STAFF, STAFF) returns (string memory) 
    {
        return super._inquiryProposalState(proposalNumber);
    }

    function inquiryProposalInformation(uint16 proposalNumber)
        public view allowPermissions(STAFF, STAFF) returns (ProposalInformation memory) 
    {
        return super._inquiryProposalInformation(proposalNumber);
    }

    function inquiryProposalId(uint16 proposalNumber)
        public view allowPermissions(STAFF, STAFF) returns (uint256) 
    {
        return super._inquiryProposalId(proposalNumber);
    }

    function executeProposal(uint16 proposalNumber) 
        public allowPermissions(PROPOSAL_MANAGER, ADMIN) returns (bool) 
    {
        return super._executeProposal(proposalNumber);
    }

    function cancelProposal(uint16 proposalNumber) 
        public allowPermissions(PROPOSAL_MANAGER, ADMIN) returns (bool) 
    {
        return super._cancelProposal(proposalNumber);
    }

}