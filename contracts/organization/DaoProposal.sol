// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/governance/utils/IVotes.sol";
import "@openzeppelin/contracts/governance/Governor.sol";

import "@openzeppelin/contracts/governance/extensions/GovernorVotesQuorumFraction.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorPreventLateQuorum.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorSettings.sol";
// import "@openzeppelin/contracts/governance/extensions/GovernorTimelockControl.sol";

import "../AccessUtils.sol";

contract DaoProposal is AccessUtils, GovernorVotesQuorumFraction, GovernorCountingSimple, GovernorPreventLateQuorum, GovernorSettings {

    // IVotes internal votes;

    constructor(
        address daoAccessControlAddress, 
        string memory domainSeparator,
        IVotes daoTokenAddress,
        uint256 quorumNumeratorValue,
        uint64 initialVoteExtension,
        uint256 initialVotingDelay,
        uint256 initialVotingPeriod,
        uint256 initialProposalThreshold) 
        Governor(domainSeparator)
        GovernorVotes(daoTokenAddress)
        GovernorVotesQuorumFraction(quorumNumeratorValue) 
        GovernorPreventLateQuorum(initialVoteExtension)
        GovernorSettings(
            initialVotingDelay, 
            initialVotingPeriod, 
            initialProposalThreshold) 
    {
        _initializeAccessControl(daoAccessControlAddress);
    }

    function proposalThreshold() 
        public view override(Governor, GovernorSettings) returns (uint256) 
    {
        return super.proposalThreshold();
    }

    function proposalDeadline(uint256 proposalId) 
        public view virtual override(Governor, GovernorPreventLateQuorum) returns (uint256) 
    {
        return super.proposalDeadline(proposalId);
    }

    function _castVote(
        uint256 proposalId,
        address account,
        uint8 support,
        string memory reason,
        bytes memory params)
        internal virtual override(Governor, GovernorPreventLateQuorum) returns (uint256) 
    {
        return super._castVote(proposalId, account, support, reason, params);
    }

    //Override by GovernorSettings
    // function votingDelay() 
    //     public view override returns (uint256) 
    // {

    // }

    //Override by GovernorSettings
    // function votingPeriod() 
    //     public view override returns (uint256) 
    // {

    // }

    // Override by GovernorVotesQuorumFraction
    // function quorum(uint256 blockNumber) 
    //     public view override returns (uint256) 
    // {

    // }

    //Override by GovernorVotes
    // function _getVotes(
    //     address account,
    //     uint256 blockNumber,
    //     bytes memory params) 
    //     internal view override returns (uint256) 
    // {

    // }


    //Override by GovernorCountingSimple
    // function COUNTING_MODE() 
    //     public pure override returns (string memory) 
    // {

    // }

    //Override by GovernorCountingSimple
    // function hasVoted(uint256 proposalId, address account) 
    //     public view override returns (bool) 
    // {

    // }

    //Override by GovernorCountingSimple
    // function _quorumReached(uint256 proposalId) 
    //     internal view override returns (bool) 
    // {

    // }

    //Override by GovernorCountingSimple
    // function _voteSucceeded(uint256 proposalId) 
    //     internal view override returns (bool) 
    // {

    // }

    //Override by GovernorCountingSimple
    // function _countVote(
    //     uint256 proposalId,
    //     address account,
    //     uint8 support,
    //     uint256 weight,
    //     bytes memory params
    // ) internal override {
        
    // }


}