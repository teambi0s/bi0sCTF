//SPDX-License-Identifier:MIT
pragma solidity ^0.8.20;

import {Script,console} from "forge-std/Script.sol";
import {Setup} from "src/Setup.sol";
import {stdJson} from "forge-std/StdJson.sol";

contract Deploy is Script{
    function run()public{
        uint256 playerEthBalance=1 ether;
        (address player,bytes32 PK)=getPlayerAddress();
        vm.startBroadcast();
        Setup _setup=new Setup();
        player.call{value:playerEthBalance}("");
        

        string memory instanceData = string.concat(
            "{\n",
            "  \"setup\": \"", vm.toString(address(_setup)), "\",\n",
            "  \"player\": \"", vm.toString(player), "\",\n",
            "  \"player_pk\": \"", vm.toString(bytes32(PK)), "\",\n",
            "  \"rpc_url\": \"", "http://127.0.0.1:8545", "\"\n",
            
            "}"
        );

        vm.writeFile("instance_details.json", instanceData);

        vm.stopBroadcast();
    }


    function getPlayerAddress()public view returns (address,bytes32){
        uint256 playerPrivateKey = uint256(keccak256(abi.encodePacked(block.timestamp)));
        address player=vm.addr(playerPrivateKey);
        return (player,bytes32(playerPrivateKey));
    }
}