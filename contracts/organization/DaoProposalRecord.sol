// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/governance/IGovernor.sol";
import "../StringUtils.sol";
import "../PublicAccessUtils.sol";

contract DaoProposalRecord is PublicAccessUtils {

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

    ProposalInformation[] private _proposalList;

    address internal recordAddress;
    address internal tokenAddress;
    address internal accessControlAddress;
    address internal proposalAddress;

    IGovernor internal DaoProposal;

    constructor (
        address daoAccessControlAddress, 
        address daoProposalAddress,
        address daoRecordAddress,
        address daoTokenAddress) {
        _initializeAccessControl(daoAccessControlAddress);
        DaoProposal = IGovernor(daoProposalAddress);

        recordAddress = daoRecordAddress;
        tokenAddress = daoTokenAddress;
        accessControlAddress = daoAccessControlAddress;
        proposalAddress = daoProposalAddress;
    }

    modifier checkNumber(uint16 proposalNumber) {
        require(_proposalList.length > proposalNumber, "The proposal number is invaild.");
        _;
    }

    modifier checkState(uint16 proposalNumber) {
        require(!_proposalList[proposalNumber].isReleased, "The proposal has released.");
        _;
    }

    function createProposal(string memory description) 
        public allowPermission(STAFF) returns (uint16) 
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
    
    function addBehaviour(
        uint16 proposalNumber,
        address target, 
        uint256 value, 
        bytes memory operation) 
        public 
        allowPermission(PROPOSAL_MANAGER)
        checkNumber(proposalNumber) 
        checkState(proposalNumber) 
    {
        Behaviour storage behaviour = _proposalList[proposalNumber].behaviours.push();
        behaviour.target = target;
        behaviour.value = value;
        behaviour.operation = operation;
        emit behaviourAdded(proposalNumber, target, value, operation);
    }

    function addRecordBehaviour(
        uint16 proposalNumber, 
        string memory infomation) 
        public 
        allowPermission(STAFF)
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
    function addTransferEthBehaviour(
        uint16 proposalNumber, 
        address receiveAddress, 
        uint256 transferValue) 
        public payable
        allowPermission(STAFF)
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

    function addMintTokenBehaviour(
        uint16 proposalNumber, 
        address mintAddress,
        uint256 mintNumber) 
        public 
        allowPermission(STAFF)
        checkNumber(proposalNumber) 
        checkState(proposalNumber)
    {
        Behaviour storage behaviour = _proposalList[proposalNumber].behaviours.push();
        behaviour.target = tokenAddress;
        behaviour.value = 0;
        behaviour.operation = abi.encodeWithSignature("mint(address,uint256)", mintAddress, mintNumber);
        emit behaviourAdded(proposalNumber, tokenAddress, 0, behaviour.operation);
    }

    function releaseProposal(uint16 proposalNumber) 
        public 
        allowPermission(PROPOSAL_MANAGER) 
        checkNumber(proposalNumber) 
        checkState(proposalNumber) 
        returns (bool) 
    {
        Behaviour[] memory behaviours = _proposalList[proposalNumber].behaviours;
        uint256 behaviourNumber = behaviours.length;
        address[] memory targets = new address[](behaviourNumber);
        uint256[] memory values = new uint256[](behaviourNumber);
        bytes[] memory calldatas = new bytes[](behaviourNumber);
        for (uint i = 0; i < behaviourNumber; i++) {
            targets[i] = behaviours[i].target;
            values[i] = behaviours[i].value;
            calldatas[i] = behaviours[i].operation;
        }
        _proposalList[proposalNumber].isReleased = true;
        string memory description = _proposalList[proposalNumber].description;
        uint256 proposalId = DaoProposal.propose(targets, values, calldatas, description);
        _proposalList[proposalNumber].proposalId = proposalId;
        return true;
    }

    function inquiryLatestProposalNumber() 
        public view  allowPermission(STAFF) returns (uint16) 
    {
        return uint16(_proposalList.length - 1);
    }

    function inquiryProposalState(uint16 proposalNumber) 
        public view 
        allowPermission(STAFF) 
        checkNumber(proposalNumber) 
        returns (string memory) 
    {
        if (!_proposalList[proposalNumber].isReleased) {
            return "Unreleased";
        }
        uint8 state = uint8(DaoProposal.state(_proposalList[proposalNumber].proposalId));
        return allStates[state];
    }

    function inquiryProposalInformation(uint16 proposalNumber)
        public view 
        allowPermission(STAFF) 
        checkNumber(proposalNumber) 
        returns (ProposalInformation memory) 
    {
        return _proposalList[proposalNumber];
    }

    function inquiryProposalId(uint16 proposalNumber)
        public view 
        allowPermission(STAFF) 
        checkNumber(proposalNumber) 
        returns (uint256) 
    {
        require(_proposalList[proposalNumber].isReleased, "The proposal is not released yet.");
        return _proposalList[proposalNumber].proposalId;
    }

    function executeProposal(uint16 proposalNumber) 
        public 
        allowPermission(PROPOSAL_MANAGER) 
        checkNumber(proposalNumber) 
        returns (bool) 
    {
        Behaviour[] memory behaviours = _proposalList[proposalNumber].behaviours;
        uint256 behaviourNumber = behaviours.length;
        address[] memory targets = new address[](behaviourNumber);
        uint256[] memory values = new uint256[](behaviourNumber);
        bytes[] memory calldatas = new bytes[](behaviourNumber);
        for (uint i = 0; i < behaviours.length; i++) {
            targets[i] = behaviours[i].target;
            values[i] = behaviours[i].value;
            calldatas[i] = behaviours[i].operation;
        }
        bytes32 descriptionHash = toHash(_proposalList[proposalNumber].description);
        DaoProposal.execute(targets, values, calldatas, descriptionHash);
        return true;
    }

    function toHash(string memory description) public pure returns (bytes32) {
        return keccak256(bytes(description));
    }

}