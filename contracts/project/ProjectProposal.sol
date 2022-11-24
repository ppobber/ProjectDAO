// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol";

import "../PublicAccessUtils.sol";

/**
 * @dev This is the project proposal contract.
 *
 * See {DaoProposal}.
 */
contract ProjectProposal is PublicAccessUtils, GovernorVotes, GovernorCountingSimple {

    bytes32 internal constant PROPOSAL_MANAGER = keccak256("PROPOSAL_MANAGER");

    uint256 private _votingDelay;
    uint256 private _votingPeriod;
    uint256 private _proposalThreshold;
    uint256 private _quorumNumber;

    constructor(
        address projectAccessControlAddress, 
        string memory projectProposalContractName,
        IVotes projectTokenAddress,
        uint256 initialVotingDelay,
        uint256 initialVotingPeriod,
        uint256 initialProposalThreshold,
        uint256 quorumNumber) 
        Governor(projectProposalContractName)
        GovernorVotes(projectTokenAddress)
    {
        _initializeAccessControl(projectAccessControlAddress);
        _votingDelay = initialVotingDelay;
        _votingPeriod = initialVotingPeriod;
        _proposalThreshold = initialProposalThreshold;
        _quorumNumber = quorumNumber;
    }

    /**
    * @dev See {DaoProposal-proposalVotes}.
    */
    function proposalVotes(uint256 proposalId)
        public view override allowPermissions(PROPOSAL_MANAGER, ADMIN)
        returns (
            uint256 againstVotes,
            uint256 forVotes,
            uint256 abstainVotes)
    {
        return super.proposalVotes(proposalId);
    }

    /**
    * @dev See {DaoProposal-quorum}.
    */
    function quorum(uint256) 
        public view override allowPermissions(STAFF, STAFF) returns (uint256) 
    {
        return _quorumNumber;
    }

    /**
    * @dev See {DaoProposal-votingDelay}.
    */
    function votingDelay() 
        public view override allowPermissions(STAFF, STAFF) returns (uint256) 
    {
        return _votingDelay;
    }

    /**
    * @dev See {DaoProposal-votingPeriod}.
    */
    function votingPeriod() 
        public view override allowPermissions(STAFF, STAFF) returns (uint256) 
    {
        return _votingPeriod;
    }

    /**
    * @dev See {DaoProposal-proposalThreshold}.
    */
    function proposalThreshold() 
        public view override allowPermissions(STAFF, STAFF) returns (uint256) 
    {
        return _proposalThreshold;
    }

    /**
    * @dev See {DaoProposal-changeVotingSetting}.
    */
    function changeVotingSetting(
        uint256 newVotingDelay, 
        uint256 newVotingPeriod, 
        uint256 newProposalThreshold,
        uint256 newQuormNumber)
        public allowPermissions(PROPOSAL_MANAGER, ADMIN) 
    {
        require(newVotingPeriod > 0, "ProjectProposal: voting period too low.");
        _votingDelay = newVotingDelay;
        _votingPeriod = newVotingPeriod;
        _proposalThreshold = newProposalThreshold;
        _quorumNumber = newQuormNumber;
    }

    /**
    * @dev See {DaoProposal-name}.
    */
    function name()
        public view override allowPermissions(MEMBER, STAFF) returns (string memory) 
    {
        return super.name();
    }

    /**
    * @dev See {DaoProposal-state}.
    */
    function state(uint256 proposalId) 
        public view override allowPermissions(STAFF, STAFF) returns (ProposalState) 
    {
        return super.state(proposalId);
    }

    /**
    * @dev See {DaoProposal-proposalSnapshot}.
    */
    function proposalSnapshot(uint256 proposalId) 
        public view override allowPermissions(STAFF, STAFF) returns (uint256) 
    {
        return super.proposalSnapshot(proposalId);
    }

    /**
    * @dev See {DaoProposal-proposalDeadline}.
    */
    function proposalDeadline(uint256 proposalId) 
        public view override allowPermissions(STAFF, STAFF) returns (uint256)
    {
        return super.proposalDeadline(proposalId);
    }

    /**
    * @dev See {DaoProposal-getVotes}.
    */
    function getVotes(address account, uint256 blockNumber)  
        public view override allowPermissions(PROPOSAL_MANAGER, ADMIN) returns (uint256)
    {
        return super.getVotes(account, blockNumber);
    }

    /**
    * @dev See {DaoProposal-getVotesWithParams}.
    */
    function getVotesWithParams(
        address account,
        uint256 blockNumber,
        bytes memory params) 
        public view override allowPermissions(PROPOSAL_MANAGER, ADMIN) returns (uint256) 
    {
        return super.getVotesWithParams(account, blockNumber, params);
    }

    /**
    * @dev See {DaoProposal-hasVoted}.
    */
    function hasVoted(uint256 proposalId, address account) 
        public view override(IGovernor, GovernorCountingSimple) 
        allowPermissions(STAFF, STAFF) 
        returns (bool) 
    {
        return super.hasVoted(proposalId, account);
    }

    /**
    * @dev See {DaoProposal-propose}.
    */
    function propose(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        string memory description) 
        public override allowPermissions(STAFF, STAFF) returns (uint256 proposalId) 
    {
        return super.propose(targets, values, calldatas, description);
    }

    /**
    * @dev See {DaoProposal-execute}.
    */
    function execute(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash) 
        public payable override allowPermissions(PROPOSAL_MANAGER, ADMIN) returns (uint256 proposalId)
    {
        return super.execute(targets, values, calldatas, descriptionHash);
    }

}