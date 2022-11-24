// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./IProposal.sol";
import "./StringUtils.sol";

/**
 * @dev The contract is the public contract for the proposal of the organization for the record contract and the proposal of the project for the record contract. 
 * 
 * Its main function is to record proposal information. And simplifying the process of writing and releasing a proposal. Because the governor's contract that uses openzeppelin directly has a lot of complications, these issues can be resolved either on-chain or off-chain. In order to streamline our current work and present a complete on-chain governance look, we chose to build a proposal record contract on the chain to assist the proposal contract. 
 */
abstract contract PublicProposalRecord {

    /**
     * @dev When a proposal is created, publish the event.
     */
    event proppsalCreated(uint16 indexed proposalNumber, bytes32 descriptionHash);

    /**
     * @dev When a specific action is added to a proposal, publish the event.
     */
    event behaviorAdded(
        uint16 indexed proposalNumber, 
        address target, 
        uint256 value, 
        bytes operation
    );

    bytes32 internal constant PROPOSAL_MANAGER = keccak256("PROPOSAL_MANAGER");

    string[] internal allStates = ["Pending", "Active", "Canceled", "Defeated", "Succeeded", "Queued", "Expired", "Executed"];

    struct Behavior {
        address target;
        uint256 value;
        bytes operation;
    }

    struct ProposalInformation {
        uint256 proposalId;
        bool isReleased;
        Behavior[] behaviors;
        string description;
        //todo, VotingDelay, VotingPeriod, ProposalThreshold, QuormNumber
    }

    ProposalInformation[] internal _proposalList;

    address internal recordAddress;
    address internal tokenAddress;
    address internal accessControlAddress;
    address internal proposalAddress;

    IProposal internal DaoProposal;

    constructor (
        address newAccessControlAddress, 
        address newProposalAddress,
        address newRecordAddress,
        address newTokenAddress) {

        DaoProposal = IProposal(newProposalAddress);

        recordAddress = newRecordAddress;
        tokenAddress = newTokenAddress;
        accessControlAddress = newAccessControlAddress;
        proposalAddress = newProposalAddress;
    }

    /**
     * @dev To make the other functions of this contract easier to use, we will extract the part that determines whether the user input is correct and use it as a modifier. Unlike the proposal number and ID, the proposal is only used in the contract, starting from scratch and incrementing by one digit each time a new proposal is created.
     */
    modifier checkNumber(uint16 proposalNumber) {
        require(_proposalList.length > proposalNumber, "The proposal number is invaild.");
        _;
    }

    /**
     * @dev Determine if the proposal has been released.
     */
    modifier checkState(uint16 proposalNumber) {
        require(!_proposalList[proposalNumber].isReleased, "The proposal has released.");
        _;
    }

    /**
     * @dev Create a proposal. 
     * 
     * Just the description is needed to create a proposal. It should be noted that since there is no judgment made on identical contracts in the governor's contract, we try not to create two identical proposals. That is, the behavior of the description and subsequent additions cannot be identical. To prevent this happen, we can choose to automatically add an increment character to the blockchain. Since character operations take up a lot of unnecessary operations, we can perform this step externally.
     */
    function _createProposal(string memory description) 
        internal virtual returns (uint16) 
    {
        uint16 proposalNumber = uint16(_proposalList.length);
        ProposalInformation storage proposalInformation = _proposalList.push();

        proposalInformation.isReleased = false;
        // string memory descriptionN = StringUtils.strConcat(StringUtils.toString(proposalNumber), description);
        proposalInformation.description = description;
        bytes32 descriptionHash = toHash(description);
        emit proppsalCreated(proposalNumber, descriptionHash);
        return proposalNumber;
    }
    
    /**
     * @dev Create an behavior for an unreleased proposal.
     *
     * @notice Due to openzeppelin's governor's contract restrictions, we must add at least one action to successfully release the proposal.
     */
    function _addBehavior(
        uint16 proposalNumber,
        address target, 
        uint256 value, 
        bytes memory operation) 
        internal virtual 
        checkNumber(proposalNumber) 
        checkState(proposalNumber) 
    {
        Behavior storage behavior = _proposalList[proposalNumber].behaviors.push();
        behavior.target = target;
        behavior.value = value;
        behavior.operation = operation;
        emit behaviorAdded(proposalNumber, target, value, operation);
    }

    /**
     * @dev Add a recording action. 
     *
     * Recording is probably the most frequently performed action of the proposal. So to simplify the process, we help users quickly add recording behavior.
     */
    function _addRecordBehavior(
        uint16 proposalNumber, 
        string memory infomation) 
        internal virtual 
        checkNumber(proposalNumber) 
        checkState(proposalNumber) 
    {
        Behavior storage behavior = _proposalList[proposalNumber].behaviors.push();
        behavior.target = recordAddress;
        behavior.value = 0;
        behavior.operation = abi.encodeWithSignature("recordInformation(string)", infomation);
        emit behaviorAdded(proposalNumber, recordAddress, 0, behavior.operation);
    }

    /**
     * @dev Add a transfer behavior. 
     *
     * @notice This function is best not used. As the final executor is the proposal contract, the proposal contract must have the corresponding eth and sufficient gas in order to ensure the correct execution of the transfer behavior. These complex relationships can easily lead to eth being locked into contracts.
     */
    function _addTransferEthBehavior(
        uint16 proposalNumber, 
        address receiveAddress, 
        uint256 transferValue) 
        internal virtual
        checkNumber(proposalNumber) 
        checkState(proposalNumber)
    {
        require(transferValue + 500000000 < msg.value , "Your transfer value is not enough.");
        Behavior storage behavior = _proposalList[proposalNumber].behaviors.push();
        behavior.target = receiveAddress;
        behavior.value = transferValue;
        behavior.operation = "";
        emit behaviorAdded(proposalNumber, receiveAddress, 0, behavior.operation);
    }

    /**
     * @dev Adds a casting token behavior. 
     *
     * In the real world, we can simulate the acquisition of a portion of the equity after the proposal passes.
     */
    function _addMintTokenBehavior(
        uint16 proposalNumber, 
        address mintAddress,
        uint256 mintNumber) 
        internal virtual 
        checkNumber(proposalNumber) 
        checkState(proposalNumber)
    {
        Behavior storage behavior = _proposalList[proposalNumber].behaviors.push();
        behavior.target = tokenAddress;
        behavior.value = 0;
        behavior.operation = abi.encodeWithSignature("mint(address,uint256)", mintAddress, mintNumber);
        emit behaviorAdded(proposalNumber, tokenAddress, 0, behavior.operation);
    }

    /**
     * @dev Release a specific proposal.
     */
    function _releaseProposal(uint16 proposalNumber) 
        internal virtual 
        checkNumber(proposalNumber) 
        checkState(proposalNumber) 
        returns (bool) 
    {
        return _release(proposalNumber);
    }

    /**
     * @dev Release a proposal and, at the same time, modify the basic attributes in the proposal contract.
     */
    function _releaseProposalWithSetting(
        uint16 proposalNumber,
        uint256 newVotingDelay, 
        uint256 newVotingPeriod, 
        uint256 newProposalThreshold,
        uint256 newQuormNumber) 
        internal virtual 
        checkNumber(proposalNumber) 
        checkState(proposalNumber) 
        returns (bool) 
    {
        DaoProposal.changeVotingSetting(newVotingDelay, newVotingPeriod, newProposalThreshold, newQuormNumber);
        return _release(proposalNumber);
    }

    /**
     * @dev Private function in proposal contract of release.
     *
     * See {IGovernor-propose}.
     */
    function _release(uint16 proposalNumber) 
        private returns (bool) 
    {
        (address[] memory targets, 
         uint256[] memory values, 
         bytes[] memory calldatas) = _arrangeBehavior(proposalNumber);

        _proposalList[proposalNumber].isReleased = true;
        string memory description = _proposalList[proposalNumber].description;
        uint256 proposalId = DaoProposal.propose(targets, values, calldatas, description);
        _proposalList[proposalNumber].proposalId = proposalId;
        return true;
    }

    /**
     * @dev Query the last proposal number. Which is the number of the newly added proposal.
     */
    function _inquiryLatestProposalNumber() 
        internal view virtual returns (uint16) 
    {
        return uint16(_proposalList.length - 1);
    }

    /**
     * @dev Query the status of a proposal.
     */
    function _inquiryProposalState(uint16 proposalNumber) 
        internal view virtual 
        checkNumber(proposalNumber) 
        returns (string memory) 
    {
        if (!_proposalList[proposalNumber].isReleased) {
            return "Unreleased";
        }
        uint8 state = uint8(DaoProposal.state(_proposalList[proposalNumber].proposalId));
        return allStates[state];
    }

    /**
     * @dev Query information about a proposal. 
     *
     * This function outputs all the information saved by the proposal.
     */
    function _inquiryProposalInformation(uint16 proposalNumber)
        internal view virtual 
        checkNumber(proposalNumber) 
        returns (ProposalInformation memory) 
    {
        return _proposalList[proposalNumber];
    }

    /**
     * @dev Query the ID of a proposal.
     */
    function _inquiryProposalId(uint16 proposalNumber)
        internal view virtual 
        checkNumber(proposalNumber) 
        returns (uint256) 
    {
        require(_proposalList[proposalNumber].isReleased, "The proposal is not released yet.");
        return _proposalList[proposalNumber].proposalId;
    }

    /**
     * @dev When a proposal is released and voted through, this function can be executed to perform all the specific behaviors in that proposal.
     * 
     * See {IGovernor-execute}.
     */
    function _executeProposal(uint16 proposalNumber) 
        internal virtual 
        checkNumber(proposalNumber) 
        returns (bool) 
    {
        (address[] memory targets, 
         uint256[] memory values, 
         bytes[] memory calldatas) = _arrangeBehavior(proposalNumber);
        bytes32 descriptionHash = toHash(_proposalList[proposalNumber].description);
        DaoProposal.execute(targets, values, calldatas, descriptionHash);
        return true;
    }

    /**
     * @dev When a proposal has been published but not yet implemented, it can be canceled.
     *
     * See {IGovernor-cancel}.
     */
    function _cancelProposal(uint16 proposalNumber) 
        internal virtual 
        checkNumber(proposalNumber) 
        returns (bool) 
    {
        (address[] memory targets, 
         uint256[] memory values, 
         bytes[] memory calldatas) = _arrangeBehavior(proposalNumber);
        bytes32 descriptionHash = toHash(_proposalList[proposalNumber].description);
        DaoProposal.cancel(targets, values, calldatas, descriptionHash);
        return true;
    }

    /**
     * @dev A function that can be easily and quickly provided to the user to convert the expected operation to a hash.
     */
    function toHash(string memory description) public pure returns (bytes32) {
        return keccak256(bytes(description));
    }

    /**
     * @dev A private function that formats our stored behavior into a format acceptable to the proposal contract.
     */
    function _arrangeBehavior(uint16 proposalNumber) 
        private view returns (
            address[] memory targets, 
            uint256[] memory values, 
            bytes[] memory calldatas) 
    {
        Behavior[] memory behaviors = _proposalList[proposalNumber].behaviors;
        uint256 behaviorNumber = behaviors.length;
        targets = new address[](behaviorNumber);
        values = new uint256[](behaviorNumber);
        calldatas = new bytes[](behaviorNumber);
        for (uint i = 0; i < behaviors.length; i++) {
            targets[i] = behaviors[i].target;
            values[i] = behaviors[i].value;
            calldatas[i] = behaviors[i].operation;
        }
    }

}