//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {Setup,Finance,DEX} from "src/Setup.sol";

contract Deploy is Script{
    Setup setup;
    Finance finance;
    DEX dex;
    function run()public {
        vm.startBroadcast();
        setup=new Setup{value : 2_72_500 ether}();
        vm.stopBroadcast();
    }


}   