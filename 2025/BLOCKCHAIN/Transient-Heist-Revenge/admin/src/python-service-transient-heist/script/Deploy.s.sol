pragma solidity ^0.8.20;

//import {Setup} from "src/core/Setup.sol";
import {Script,console} from "forge-std/Script.sol";
import {USDS,USDC,WETH,SafeMoon,Setup} from "src/core/Setup.sol";
import {IBi0sSwapFactory} from "src/bi0s-swap-v1/interfaces/IBi0sSwapFactory.sol";
import {IBi0sSwapPair} from "src/bi0s-swap-v1/interfaces/IBi0sSwapPair.sol";

contract Deploy is Script{

    function run()public{
        uint256 WETH_INITIAL_MINT=225539152795198000*2e18;  
        vm.startBroadcast();
        uint256 playerEthBalance=80001e18;
        (address player,bytes32 PK)=getPlayerAddress();
        address bi0sSwapFactory=address(uint160(uint256(keccak256(abi.encodePacked(hex"d6_94", msg.sender, hex"80")))));
        Setup setup=new Setup{value:WETH_INITIAL_MINT}();
        Bi0sSwapPoolsDeployHelper bi0sSwapPoolCreator=new Bi0sSwapPoolsDeployHelper(bi0sSwapFactory,address(setup));
        setup.initialize(address(bi0sSwapPoolCreator),bi0sSwapFactory);
        player.call{value:playerEthBalance}("");

        string memory instanceData = string.concat(
            "{\n",
            "  \"setup\": \"", vm.toString(address(setup)), "\",\n",
            "  \"player\": \"", vm.toString(player), "\",\n",
            "  \"player_pk\": \"", vm.toString(bytes32(PK)), "\"\n",
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


contract Bi0sSwapPoolsDeployHelper{
    IBi0sSwapFactory public bi0sSwapFactory;
    Setup public setup;

    IBi0sSwapPair public wethUsdcPair;
    IBi0sSwapPair public wethSafeMoonPair;
    IBi0sSwapPair public safeMoonUsdcPair;

    constructor(address _bi0sSwapFactory,address _setup){
        bi0sSwapFactory=IBi0sSwapFactory(_bi0sSwapFactory);
        setup=Setup(_setup);
        address usdc=address(setup.usdc());
        address safeMoon=address(setup.safeMoon());
        address weth=address(setup.weth());

        wethUsdcPair=IBi0sSwapPair(bi0sSwapFactory.createPair(weth, usdc));
        wethSafeMoonPair=IBi0sSwapPair(bi0sSwapFactory.createPair(weth, safeMoon));
        safeMoonUsdcPair=IBi0sSwapPair(bi0sSwapFactory.createPair(safeMoon, usdc));

    }


}