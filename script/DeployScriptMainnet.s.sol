pragma solidity 0.8.20;

import {Heires} from "../src/Heires.sol";

import "forge-std/Script.sol";

contract DeployScriptMainnet is Script {
    address descendantModule0 = 0x8F4715485A25309322D7E095C4bF4Fdb2A0FdC92;
    address descendantModule1 = 0x8F4715485A25309322D7E095C4bF4Fdb2A0FdC92;
    address descendantModule2 = 0x8F4715485A25309322D7E095C4bF4Fdb2A0FdC92;
    address descendantModule3 = 0x8F4715485A25309322D7E095C4bF4Fdb2A0FdC92;
    address descendantModule4 = 0x8F4715485A25309322D7E095C4bF4Fdb2A0FdC92;

    function run() public returns (Heires heirloom) {
        heirloom = new Heires(descendantModule0, descendantModule1, descendantModule2, descendantModule3, descendantModule4);
    }
}
