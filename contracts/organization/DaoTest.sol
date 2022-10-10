// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract DaoTest is AccessControl {


    event someOutputs(string newValue);


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



    // modifier teststring(string memory _name) {
    //     emit someOutputs(_name);
    //     _;
    // }

    // function trytodo() teststring("dfaffdadf") public {
    //     emit someOutputs("dfafadfafda");
    // }
}