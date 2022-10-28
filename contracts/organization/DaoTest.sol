// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// import "@openzeppelin/contracts/access/AccessControl.sol";

contract DaoTest {


    // event someOutputs(string newValue);

    // struct aa {
    //     mapping (bytes => bool) name;
    //     uint isis;
    // }

    // mapping (uint => bool) tete;
    // mapping (uint => aa) tete2;

    // uint asa = 0;

    // enum VoteType {
    //     Against,
    //     For,
    //     Abstain
    // }

    // function te(address _addr) public payable returns (bool, bytes memory) {
    //     (bool send, bytes memory data) = _addr.call{value: 0, gas: 500000}(
    //         abi.encodeWithSignature("mememe()"));
    //     require(send, "Failed.");
    //     return (send, data);
    // }

    // function te2(address _addr) public payable returns (bool, bytes memory) {
    //     (bool send, bytes memory data) = _addr.call{value: 0, gas: 500000}(
    //         abi.encodeWithSignature("mememe2()"));
    //     require(send, "Failed.");
    //     return (send, data);
    // }

    // function changeBytes() public pure returns (bytes memory) {
    //     return abi.encodeWithSignature("recordInformation(string)", "Slogan: Think Different.");
    // }

    // function changeBytes2() public pure returns (bytes32) {
    //     return keccak256(bytes("Minjia wants to record information of organizaitonal slogan in blockchain."));
    // }

    function callRecord(address addr) public payable {
        (bool send, bytes memory data) =  0xeF50110EAc01512796e7AaFEe68458800A4bD358.call{value: 0}(
            abi.encodeWithSignature("recordInformation(string)", "Slogan: Think Different."));
        require(send, "Failed.");
    }

    // function voteBytes(uint number) public pure returns (uint8) {
    //     if (number == 0) {
    //         return uint8(VoteType.Against);
    //     } else if (number == 1) {
    //         return uint8(VoteType.For);
    //     } else {
    //         return uint8(VoteType.Abstain);
    //     }
    // }



    // function inquiry() public view returns(uint) {
    //     return asa;
    // }

    function senTo(address _addr, uint values, uint gass) public payable returns (bool, bytes memory) {
        (bool send, bytes memory data) = _addr.call{value: values, gas: gass}(
            abi.encodeWithSignature("dd()"));
        require(send, "Failed.");
        return (send, data);
    }


    // function test(bool[] memory _accessibleRoles) public pure returns(bool)  {
    //     bool ifRoles = false;
    //     for (uint i = 0; i <_accessibleRoles.length; ++i) {
    //         if (_accessibleRoles[i] == true) {
    //             ifRoles = true;
    //             break;
    //         }
    //     }
    //     return(ifRoles);
    // }

    // function trydy() public {
    //     bool[] memory accessibleRoles = new bool[](2);
    //     accessibleRoles[0] = true;
    //     accessibleRoles[1] = false;

    //     require(test(accessibleRoles), "this permission not from you");

    //     emit someOutputs("hello world.");
    // }

    // function testString(string memory a) public {
    //     emit someOutputs(a);
    // }

    // function testBytes(bytes memory a) public {
    //     emit someOutputs(string(a));
    // }

    // function testReturn() public returns(mapping (uint => bool) memory) {
    //     tete[1] = true;
    //     tete[2] = false;
    //     tete[3] = true;

    //     return tete;
    // }

    // function testReturn2() public returns(mapping (uint => aa) memory) {
    //     tete2[1].name["dfdf"] = true;
    //     tete2[1].isis = 11;
    //     tete2[2].name["dfdf"] = true;
    //     tete2[2].isis = 11;
    //     tete2[3].name["dfdf"] = true;
    //     tete2[3].isis = 11;

    //     return tete2;
    // }



    // modifier teststring(string memory _name) {
    //     emit someOutputs(_name);
    //     _;
    // }

    // function trytodo() teststring("dfaffdadf") public {
    //     emit someOutputs("dfafadfafda");
    // }
}