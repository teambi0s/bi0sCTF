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
        (address player,bytes32 PK)=getPlayerAddress();
        player.call{value: 1 ether}("");
        vm.stopBroadcast();
        
        string memory instanceData = string.concat(
            "{\n",
            "  \"setup\": \"", vm.toString(address(setup)), "\",\n",
            "  \"player\": \"", vm.toString(player), "\",\n",
            "  \"player_pk\": \"", vm.toString(bytes32(PK)), "\"\n",
            "}"
        );

        vm.writeFile("instance_details.json", instanceData);


    }


    function getPlayerAddress()public view returns (address,bytes32){
        uint256 playerPrivateKey = uint256(keccak256(abi.encodePacked(block.timestamp)));
        address player=vm.addr(playerPrivateKey);
        return (player,bytes32(playerPrivateKey));
    }
}   