// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol";

import "../PublicAccessUtils.sol";

//enable optimization (run: 200) to compile Proposal contract.
contract DaoProposal is PublicAccessUtils, GovernorVotes, GovernorCountingSimple {

    bytes32 internal constant PROPOSAL_MANAGER = keccak256("PROPOSAL_MANAGER");

    uint256 private _votingDelay;
    uint256 private _votingPeriod;
    uint256 private _proposalThreshold;
    uint256 private _quorumNumber;

    constructor(
        address daoAccessControlAddress, 
        string memory daoProposalContractName,
        IVotes daoTokenAddress,
        uint256 initialVotingDelay,
        uint256 initialVotingPeriod,
        uint256 initialProposalThreshold,
        uint256 initialquorumNumber) 
        Governor(daoProposalContractName)
        GovernorVotes(daoTokenAddress)
    {
        _initializeAccessControl(daoAccessControlAddress);
        _votingDelay = initialVotingDelay;
        _votingPeriod = initialVotingPeriod;
        _proposalThreshold = initialProposalThreshold;
        _quorumNumber = initialquorumNumber;
    }

    //GovernorCountingSimple
    function proposalVotes(uint256 proposalId)
        public view override allowPermission(PROPOSAL_MANAGER)
        returns (
            uint256 againstVotes,
            uint256 forVotes,
            uint256 abstainVotes)
    {
        return super.proposalVotes(proposalId);
    }

    //user-config
    function quorum(uint256) 
        public view override allowPermission(STAFF) returns (uint256) 
    {
        return _quorumNumber;
    }

    function votingDelay() 
        public view override allowPermission(STAFF) returns (uint256) 
    {
        return _votingDelay;
    }

    function votingPeriod() 
        public view override allowPermission(STAFF) returns (uint256) 
    {
        return _votingPeriod;
    }

    function proposalThreshold() 
        public view override allowPermission(STAFF) returns (uint256) 
    {
        return _proposalThreshold;
    }

    function changeVotingSetting(
        uint256 newVotingDelay, 
        uint256 newVotingPeriod, 
        uint256 newProposalThreshold,
        uint256 newQuormNumber)
        public allowPermission(PROPOSAL_MANAGER) 
    {
        require(newVotingPeriod > 0, "DaoProposal: voting period too low.");
        _votingDelay = newVotingDelay;
        _votingPeriod = newVotingPeriod;
        _proposalThreshold = newProposalThreshold;
        _quorumNumber = newQuormNumber;
    }

    //IGovernor
    function name()
        public view override allowPermission(MEMBER) returns (string memory) 
    {
        return super.name();
    }

    // cannot add modifier because Governor.sol calls version() in constructor.
    // function version() public view override returns (string memory) {
    //     return super.version();
    // }

    function state(uint256 proposalId) 
        public view override allowPermission(STAFF) returns (ProposalState) 
    {
        return super.state(proposalId);
    }

    function proposalSnapshot(uint256 proposalId) 
        public view override allowPermission(STAFF) returns (uint256) 
    {
        return super.proposalSnapshot(proposalId);
    }

    function proposalDeadline(uint256 proposalId) 
        public view override allowPermission(STAFF) returns (uint256)
    {
        return super.proposalDeadline(proposalId);
    }

    function getVotes(address account, uint256 blockNumber)  
        public view override allowPermission(PROPOSAL_MANAGER) returns (uint256)
    {
        return super.getVotes(account, blockNumber);
    }

    function getVotesWithParams(
        address account,
        uint256 blockNumber,
        bytes memory params) 
        public view override allowPermission(PROPOSAL_MANAGER) returns (uint256) 
    {
        return super.getVotesWithParams(account, blockNumber, params);
    }

    function hasVoted(uint256 proposalId, address account) 
        public view override(IGovernor, GovernorCountingSimple) 
        allowPermission(STAFF) 
        returns (bool) 
    {
        return super.hasVoted(proposalId, account);
    }

    function propose(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        string memory description) 
        public override allowPermission(STAFF) returns (uint256 proposalId) 
    {
        return super.propose(targets, values, calldatas, description);
    }

    function execute(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash) 
        public payable override allowPermission(PROPOSAL_MANAGER) returns (uint256 proposalId)
    {
        return super.execute(targets, values, calldatas, descriptionHash);
    }


    // function castVote(uint256 proposalId, uint8 support) 
    //     public override allowPermission(STAFF) returns (uint256 balance) 
    // {
    //     return super.castVote(proposalId, support);
    // }

    // function castVoteWithReason(
    //     uint256 proposalId,
    //     uint8 support,
    //     string calldata reason) 
    //     public override allowPermission(STAFF) returns (uint256 balance) 
    // {
    //     return super.castVoteWithReason(proposalId, support, reason);
    // }

    // function castVoteWithReasonAndParams(
    //     uint256 proposalId,
    //     uint8 support,
    //     string calldata reason,
    //     bytes memory params) 
    //     public override allowPermission(STAFF) returns (uint256 balance)
    // {
    //     return super.castVoteWithReasonAndParams(proposalId,support, reason, params);
    // }

    // function castVoteBySig(
    //     uint256 proposalId,
    //     uint8 support,
    //     uint8 v,
    //     bytes32 r,
    //     bytes32 s) 
    //     public override allowPermission(STAFF) returns (uint256 balance)
    // {
    //     return super.castVoteBySig(proposalId, support, v, r, s);
    // }

    // function castVoteWithReasonAndParamsBySig(
    //     uint256 proposalId,
    //     uint8 support,
    //     string calldata reason,
    //     bytes memory params,
    //     uint8 v,
    //     bytes32 r,
    //     bytes32 s) 
    //     public override allowPermission(STAFF) returns (uint256 balance) 
    // {
    //     return super.castVoteWithReasonAndParamsBySig(proposalId, support, reason, params, v, r, s);
    // }

}