// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// import "@openzeppelin/contracts/access/AccessControl.sol";

contract DaoTest2 {

    event dododo(string indexed dd);
    uint32 aa = 0;

    string[] internal info;

    function mememe() external payable returns(uint32) {
        // emit dododo("fagafdagd");
        aa += 3;
        // info.push(information);
        info.push("Zoe");
        return aa;
    }

    function mememe2() external payable returns(uint32) {
        // emit dododo("fagafdagd");
        aa += 3;
        // info.push(information);
        // info.push("Zoe");
        return aa;
    }

    // function inqu() public view returns(uint32) {
    //     return aa;
    // }

    // function recordInfo(string memory information) public returns(bool) {
    //     info.push(information);
    //     return true;
    // }

    function checkInfo() public view returns(string[] memory) {
        return info;
    }

    function inquiryBlock() public view returns(uint256) {
        return block.number;
    }

}