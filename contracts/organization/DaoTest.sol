// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract DaoTest is AccessControl {


    event someOutputs(string newValue);

    struct aa {
        mapping (bytes => bool) name;
        uint isis;
    }

    mapping (uint => bool) tete;
    mapping (uint => aa) tete2;


    function test(bool[] memory _accessibleRoles) public pure returns(bool)  {
        bool ifRoles = false;
        for (uint i = 0; i <_accessibleRoles.length; ++i) {
            if (_accessibleRoles[i] == true) {
                ifRoles = true;
                break;
            }
        }
        return(ifRoles);
    }

    function trydy() public {
        bool[] memory accessibleRoles = new bool[](2);
        accessibleRoles[0] = true;
        accessibleRoles[1] = false;

        require(test(accessibleRoles), "this permission not from you");

        emit someOutputs("hello world.");
    }

    function testString(string memory a) public {
        emit someOutputs(a);
    }

    function testBytes(bytes memory a) public {
        emit someOutputs(string(a));
    }

    function testReturn() public returns(mapping (uint => bool) memory) {
        tete[1] = true;
        tete[2] = false;
        tete[3] = true;

        return tete;
    }

    function testReturn2() public returns(mapping (uint => aa) memory) {
        tete2[1].name["dfdf"] = true;
        tete2[1].isis = 11;
        tete2[2].name["dfdf"] = true;
        tete2[2].isis = 11;
        tete2[3].name["dfdf"] = true;
        tete2[3].isis = 11;

        return tete2;
    }



    // modifier teststring(string memory _name) {
    //     emit someOutputs(_name);
    //     _;
    // }

    // function trytodo() teststring("dfaffdadf") public {
    //     emit someOutputs("dfafadfafda");
    // }
}