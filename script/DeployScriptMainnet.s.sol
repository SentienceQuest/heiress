pragma solidity 0.8.20;

import {Heires} from "../src/Heires.sol";

import "forge-std/Script.sol";

contract DeployScriptMainnet is Script {
    address descendantModule0 = 0xFB3a1745e9dDb9bd40a3f395bc76C4fd1A85c96c;
    address descendantModule1 = 0xFB3a1745e9dDb9bd40a3f395bc76C4fd1A85c96c;
    address descendantModule2 = 0xFB3a1745e9dDb9bd40a3f395bc76C4fd1A85c96c;
    address descendantModule3 = 0xFB3a1745e9dDb9bd40a3f395bc76C4fd1A85c96c;
    address descendantModule4 = 0xFB3a1745e9dDb9bd40a3f395bc76C4fd1A85c96c;

    function run() public returns (Heires heirloom) {
        heirloom = new Heires(descendantModule0, descendantModule1, descendantModule2, descendantModule3, descendantModule4);
    }
}
