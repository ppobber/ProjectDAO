// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./IProposal.sol";
import "./StringUtils.sol";

abstract contract PublicProposalRecord {

    event proppsalCreated(uint16 indexed proposalNumber, bytes32 descriptionHash);

    event behaviourAdded(
        uint16 indexed proposalNumber, 
        address target, 
        uint256 value, 
        bytes operation
    );

    bytes32 internal constant PROPOSAL_MANAGER = keccak256("PROPOSAL_MANAGER");

    string[] internal allStates = ["Pending", "Active", "Canceled", "Defeated", "Succeeded", "Queued", "Expired", "Executed"];

    struct Behaviour {
        address target;
        uint256 value;
        bytes operation;
    }

    struct ProposalInformation {
        uint256 proposalId;
        bool isReleased;
        Behaviour[] behaviours;
        string description;
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

    modifier checkNumber(uint16 proposalNumber) {
        require(_proposalList.length > proposalNumber, "The proposal number is invaild.");
        _;
    }

    modifier checkState(uint16 proposalNumber) {
        require(!_proposalList[proposalNumber].isReleased, "The proposal has released.");
        _;
    }

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

    // function createTest(string memory description) 
    //     public returns (ProposalInformation memory) 
    // {
    //     // uint256 proposalNumber = _proposalList.length;
    //     ProposalInformation storage proposalInformation = _proposalList.push();

    //     proposalInformation.isReleased = false;
    //     // string memory descriptionN = StringUtils.strConcat(StringUtils.toString(proposalNumber), description);
    //     proposalInformation.description = description;
    //     // bytes32 descriptionHash = keccak256(bytes(description));
    //     // emit proppsalCreated(proposalNumber, descriptionHash);
    //     return proposalInformation;
    // }
    
    function _addBehaviour(
        uint16 proposalNumber,
        address target, 
        uint256 value, 
        bytes memory operation) 
        internal virtual 
        checkNumber(proposalNumber) 
        checkState(proposalNumber) 
    {
        Behaviour storage behaviour = _proposalList[proposalNumber].behaviours.push();
        behaviour.target = target;
        behaviour.value = value;
        behaviour.operation = operation;
        emit behaviourAdded(proposalNumber, target, value, operation);
    }

    function _addRecordBehaviour(
        uint16 proposalNumber, 
        string memory infomation) 
        internal virtual 
        checkNumber(proposalNumber) 
        checkState(proposalNumber) 
    {
        Behaviour storage behaviour = _proposalList[proposalNumber].behaviours.push();
        behaviour.target = recordAddress;
        behaviour.value = 0;
        behaviour.operation = abi.encodeWithSignature("recordInformation(string)", infomation);
        emit behaviourAdded(proposalNumber, recordAddress, 0, behaviour.operation);
    }

    //It will cause unexpected results. It's not good to transfer eth by contract.
    function _addTransferEthBehaviour(
        uint16 proposalNumber, 
        address receiveAddress, 
        uint256 transferValue) 
        internal virtual
        checkNumber(proposalNumber) 
        checkState(proposalNumber)
    {
        require(transferValue + 500000000 < msg.value , "Your transfer value is not enough.");
        Behaviour storage behaviour = _proposalList[proposalNumber].behaviours.push();
        behaviour.target = receiveAddress;
        behaviour.value = transferValue;
        behaviour.operation = "";
        emit behaviourAdded(proposalNumber, receiveAddress, 0, behaviour.operation);
    }

    function _addMintTokenBehaviour(
        uint16 proposalNumber, 
        address mintAddress,
        uint256 mintNumber) 
        internal virtual 
        checkNumber(proposalNumber) 
        checkState(proposalNumber)
    {
        Behaviour storage behaviour = _proposalList[proposalNumber].behaviours.push();
        behaviour.target = tokenAddress;
        behaviour.value = 0;
        behaviour.operation = abi.encodeWithSignature("mint(address,uint256)", mintAddress, mintNumber);
        emit behaviourAdded(proposalNumber, tokenAddress, 0, behaviour.operation);
    }

    function _releaseProposal(uint16 proposalNumber) 
        internal virtual 
        checkNumber(proposalNumber) 
        checkState(proposalNumber) 
        returns (bool) 
    {
        return _release(proposalNumber);
    }

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

    function _release(uint16 proposalNumber) 
        private returns (bool) 
    {
        (address[] memory targets, 
         uint256[] memory values, 
         bytes[] memory calldatas) = _arrangeBehaviour(proposalNumber);

        _proposalList[proposalNumber].isReleased = true;
        string memory description = _proposalList[proposalNumber].description;
        uint256 proposalId = DaoProposal.propose(targets, values, calldatas, description);
        _proposalList[proposalNumber].proposalId = proposalId;
        return true;
    }

    function _inquiryLatestProposalNumber() 
        internal view virtual returns (uint16) 
    {
        return uint16(_proposalList.length - 1);
    }

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

    function _inquiryProposalInformation(uint16 proposalNumber)
        internal view virtual 
        checkNumber(proposalNumber) 
        returns (ProposalInformation memory) 
    {
        return _proposalList[proposalNumber];
    }

    function _inquiryProposalId(uint16 proposalNumber)
        internal view virtual 
        checkNumber(proposalNumber) 
        returns (uint256) 
    {
        require(_proposalList[proposalNumber].isReleased, "The proposal is not released yet.");
        return _proposalList[proposalNumber].proposalId;
    }

    function _executeProposal(uint16 proposalNumber) 
        internal virtual 
        checkNumber(proposalNumber) 
        returns (bool) 
    {
        (address[] memory targets, 
         uint256[] memory values, 
         bytes[] memory calldatas) = _arrangeBehaviour(proposalNumber);
        bytes32 descriptionHash = toHash(_proposalList[proposalNumber].description);
        DaoProposal.execute(targets, values, calldatas, descriptionHash);
        return true;
    }

    function _cancelProposal(uint16 proposalNumber) 
        internal virtual 
        checkNumber(proposalNumber) 
        returns (bool) 
    {
        (address[] memory targets, 
         uint256[] memory values, 
         bytes[] memory calldatas) = _arrangeBehaviour(proposalNumber);
        bytes32 descriptionHash = toHash(_proposalList[proposalNumber].description);
        DaoProposal.cancel(targets, values, calldatas, descriptionHash);
        return true;
    }

    function toHash(string memory description) public pure returns (bytes32) {
        return keccak256(bytes(description));
    }

    function _arrangeBehaviour(uint16 proposalNumber) 
        private view returns (
            address[] memory targets, 
            uint256[] memory values, 
            bytes[] memory calldatas) 
    {
        Behaviour[] memory behaviours = _proposalList[proposalNumber].behaviours;
        uint256 behaviourNumber = behaviours.length;
        targets = new address[](behaviourNumber);
        values = new uint256[](behaviourNumber);
        calldatas = new bytes[](behaviourNumber);
        for (uint i = 0; i < behaviours.length; i++) {
            targets[i] = behaviours[i].target;
            values[i] = behaviours[i].value;
            calldatas[i] = behaviours[i].operation;
        }
    }

}