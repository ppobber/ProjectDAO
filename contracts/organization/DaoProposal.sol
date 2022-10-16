// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/governance/utils/IVotes.sol";
import "@openzeppelin/contracts/governance/Governor.sol";

import "../AccessUtils.sol";

contract DaoProposal is AccessUtils, Governor {

    IVotes internal votes;

    constructor(address daoAccessControlAddress, address daoTokenAddress, string memory name) Governor(name) {
        _initializeAccessControl(daoAccessControlAddress);
        votes = IVotes(daoTokenAddress);
    }


    function votingDelay() public view override returns (uint256) {

    }

    function votingPeriod() public view override returns (uint256) {

    }

    function quorum(uint256 blockNumber) public view override returns (uint256) {

    }

    function COUNTING_MODE() public pure override returns (string memory) {

    }

    function hasVoted(uint256 proposalId, address account) public view override returns (bool) {

    }

    function _quorumReached(uint256 proposalId) internal view override returns (bool) {}


    function _voteSucceeded(uint256 proposalId) internal view override returns (bool) {}


    function _getVotes(
        address account,
        uint256 blockNumber,
        bytes memory params
    ) internal view override returns (uint256) {}


    function _countVote(
        uint256 proposalId,
        address account,
        uint8 support,
        uint256 weight,
        bytes memory params
    ) internal override {
        
    }






    // function name() public view override returns (string memory) {

    // }

    // function version() public view override returns (string memory) {}

    // function hashProposal(
    //     address[] memory targets,
    //     uint256[] memory values,
    //     bytes[] memory calldatas,
    //     bytes32 descriptionHash
    // ) public pure override returns (uint256) {

    // }

    // function state(uint256 proposalId) public view override returns (ProposalState) {}

    // function proposalSnapshot(uint256 proposalId) public view override returns (uint256){}

    // function proposalDeadline(uint256 proposalId) public view override returns (uint256){}

    // function getVotes(address account, uint256 blockNumber) public view override returns (uint256) {}

    // function getVotesWithParams(
    //     address account,
    //     uint256 blockNumber,
    //     bytes memory params
    // ) public view override returns (uint256) {}

    // function propose(
    //     address[] memory targets,
    //     uint256[] memory values,
    //     bytes[] memory calldatas,
    //     string memory description
    // ) public override returns (uint256 proposalId) {}

    // function execute(
    //     address[] memory targets,
    //     uint256[] memory values,
    //     bytes[] memory calldatas,
    //     bytes32 descriptionHash
    // ) public payable override returns (uint256 proposalId){}

    // function castVoteWithReason(
    //     uint256 proposalId,
    //     uint8 support,
    //     string calldata reason
    // ) public override returns (uint256 balance){}

    // function castVoteWithReasonAndParams(
    //     uint256 proposalId,
    //     uint8 support,
    //     string calldata reason,
    //     bytes memory params
    // ) public override returns (uint256 balance){}

    // function castVoteBySig(
    //     uint256 proposalId,
    //     uint8 support,
    //     uint8 v,
    //     bytes32 r,
    //     bytes32 s
    // ) public override returns (uint256 balance){}

    // function castVoteWithReasonAndParamsBySig(
    //     uint256 proposalId,
    //     uint8 support,
    //     string calldata reason,
    //     bytes memory params,
    //     uint8 v,
    //     bytes32 r,
    //     bytes32 s
    // ) public override returns (uint256 balance) 
    // {

    // }


}