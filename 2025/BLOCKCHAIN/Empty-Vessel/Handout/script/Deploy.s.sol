//SPDX-License-Identifier:MIT
pragma solidity ^0.8.20;

import {Script,console} from "forge-std/Script.sol";
import {Setup} from "src/Setup.sol";


contract Deploy is Script{
    function run()public{
        vm.startBroadcast();
        Setup _setup=new Setup();
        vm.stopBroadcast();
    }


}