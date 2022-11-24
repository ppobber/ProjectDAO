// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol";

import "../PublicAccessUtils.sol";

/**
 * @dev The organizational proposal contract inherits to openzeppelin's governor contract and a series of its extensions. Although openzeppelin's proposed approach was not in line with our business needs to some extent, due to its sophisticated extension capabilities and rigorous code logic, we chose to directly use inheritance to obtain functionality, saving us a lot of work. In the future, it makes perfect sense if other teams want to completely rewrite the proposal contract based on business requirements, as well as reduce the size of the contract by eliminating a lot of unused functionality.
 *
 * Because openzeppelin's governor includes overly complete functionality, oversizing at compile time is almost inevitable. So when we compile, we need to use compile optimization. Refactoring your code might prevent this from happening.
 *
 * @notice Enable optimization (run: 200) to compile Proposal contract.
 */
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

    /**
     * @dev Overrides functions in the GovernorCountingSimple extension. All votes on the current proposal are available.
     */
    function proposalVotes(uint256 proposalId)
        public view override allowPermission(PROPOSAL_MANAGER)
        returns (
            uint256 againstVotes,
            uint256 forVotes,
            uint256 abstainVotes)
    {
        return super.proposalVotes(proposalId);
    }
 
    /**
     * @dev Overrides the functions in the governer contract as part of the user configuration. The minimum required number of voters can be queried.
     */
    function quorum(uint256) 
        public view override allowPermission(STAFF) returns (uint256) 
    {
        return _quorumNumber;
    }

    /**
     * @dev Overrides the functions in the governer contract as part of the user configuration. We can query the delay time for the start of voting.
     */
    function votingDelay() 
        public view override allowPermission(STAFF) returns (uint256) 
    {
        return _votingDelay;
    }

    /**
     * @dev Overrides the functions in the governer contract as part of the user configuration. We can query the voting time length.
     */
    function votingPeriod() 
        public view override allowPermission(STAFF) returns (uint256) 
    {
        return _votingPeriod;
    }

    /**
     * @dev Overrides the functions in the governer contract as part of the user configuration. The minimum number of tokens required by the proposal publisher can be queried.
     */
    function proposalThreshold() 
        public view override allowPermission(STAFF) returns (uint256) 
    {
        return _proposalThreshold;
    }

    /**
     * @dev Can modify all basic properties at once.
     */
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

    /**
     * @dev Overrides functions in the governor contract. The name of the proposed contract can be found. The name is set when the contract is initialized.
     */
    function name()
        public view override allowPermission(MEMBER) returns (string memory) 
    {
        return super.name();
    }

    /**
     * @dev With a proposal ID, we can get the current status of the proposal.
     */
    function state(uint256 proposalId) 
        public view override allowPermission(STAFF) returns (ProposalState) 
    {
        return super.state(proposalId);
    }

    /**
     * @dev With a proposal ID, we can get the block where the proposal starts.
     */
    function proposalSnapshot(uint256 proposalId) 
        public view override allowPermission(STAFF) returns (uint256) 
    {
        return super.proposalSnapshot(proposalId);
    }

    /**
     * @dev With a proposal ID, we can get the deadline for the proposal.
     */
    function proposalDeadline(uint256 proposalId) 
        public view override allowPermission(STAFF) returns (uint256)
    {
        return super.proposalDeadline(proposalId);
    }

    /**
     * @dev Using this function, we can get the voting rights of a certain account in a certain block. This function calls the query function in the token contract.
     */
    function getVotes(address account, uint256 blockNumber)  
        public view override allowPermission(PROPOSAL_MANAGER) returns (uint256)
    {
        return super.getVotes(account, blockNumber);
    }

    /**
     * @dev The function can also get the voting rights of a certain account in a certain block. Just to match the query function in the token contract.
     */
    function getVotesWithParams(
        address account,
        uint256 blockNumber,
        bytes memory params) 
        public view override allowPermission(PROPOSAL_MANAGER) returns (uint256) 
    {
        return super.getVotesWithParams(account, blockNumber, params);
    }

    /**
     * @dev Query whether a vote has been cast for an account.
     */
    function hasVoted(uint256 proposalId, address account) 
        public view override(IGovernor, GovernorCountingSimple) 
        allowPermission(STAFF) 
        returns (bool) 
    {
        return super.hasVoted(proposalId, account);
    }

    /**
     * @dev Put out a proposal. Since this function is native to the governor contract, all arguments are passed in as an array. It's going to be messy.
     */
    function propose(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        string memory description) 
        public override allowPermission(STAFF) returns (uint256 proposalId) 
    {
        return super.propose(targets, values, calldatas, description);
    }

    /**
     * @dev Implement a proposal. 
     *
     * @notice that all parameters passed in must be exactly the same as when they were published in order to get the same ID for successful execution.
     */
    function execute(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash) 
        public payable override allowPermission(PROPOSAL_MANAGER) returns (uint256 proposalId)
    {
        return super.execute(targets, values, calldatas, descriptionHash);
    }

    /**
     * @dev Cancel a proposal. Similar to the execution function.
     */
    function cancel(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash) 
        public allowPermission(PROPOSAL_MANAGER) returns (uint256 proposalId)
    {
        return super._cancel(targets, values, calldatas, descriptionHash);
    }

}