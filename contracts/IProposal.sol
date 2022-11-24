// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/governance/IGovernor.sol";

/**
 * @dev This contract inherits directly from openzeppelin's IGovernor interface to extend the external accessibility of the Governor's contract.
 * 
 * If you have any question, add wechat: yuyyyyyue
 */
abstract contract IProposal is IGovernor {

    /**
     * @dev Quickly modify four important attributes of the proposal.
     *
     * @notice Openzeppelin sets these four values as global variables, they should not be changed frequently in most cases. However, for the sake of our project, we did provide this modifiable function that allows different data to be modified each time a proposal is released, and all specific data about the proposal is stored in the proposal record contract. (Consider writing parameters to the mapping when refactoring code.)
     */
    function changeVotingSetting(
        uint256 newVotingDelay, 
        uint256 newVotingPeriod, 
        uint256 newProposalThreshold,
        uint256 newQuormNumber
    ) public virtual;

    /**
     * @dev To cancel a proposal.
     *
     * @notice Openzeppelin provides only two function interfaces, execute and propose, and does not provide a method to cancel a proposal. Since canceling a proposal is already a less risky behavior under our permission control, we can accept writing a canceling proposal to the interface. It is also convenient to be used by the proposal record directly.
     */
    function cancel(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    ) public virtual returns (uint256 proposalId);

}


