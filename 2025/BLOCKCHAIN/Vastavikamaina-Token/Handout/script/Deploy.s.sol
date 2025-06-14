//SPDX-License-Identifier-MIT
pragma solidity ^0.8.20;

import {Setup} from "src/core/Setup.sol";
import {Script,console} from "forge-std/Script.sol";
import {WhiteListed} from "src/core/WhiteListed.sol";
import {LamboToken} from "src/core/LamboToken.sol";
import {WETH9} from "src/core/WETH.sol";
import {Balancer} from "src/core/Balancer.sol";
import {Factory} from "src/core/Factory.sol";
interface IuniswapFactory{
    function getBytecode()external returns (bytes32);
}

contract Deploy is Script{

    Setup public setup;
    uint256 liquidityAmount = 32560203560896180352774;
    uint256 vETHBalanceTo_VETH_HBL=132534758877722247977 - (3.3 ether);
    uint256 vETHBalanceTo_VETH_CBO=5007791505809550535 - 0.05 ether;
    uint256 vETHBalanceTo_VETH_BIN=3852171628908871705- 3 ether;
    uint256 amount=liquidityAmount+vETHBalanceTo_VETH_HBL+vETHBalanceTo_VETH_CBO+vETHBalanceTo_VETH_BIN;
    function run()public{
        vm.startBroadcast();
        address uniswapFactory=address(uint160(uint256(keccak256(abi.encodePacked(hex"d6_94", msg.sender, hex"80")))));
        setup=new Setup{value: 6.35 ether}(uniswapFactory);
        WhiteListed _whiteListed=setup.whilteListed();
        Factory _factory=setup.factory();
        bytes32 _initHash=IuniswapFactory(uniswapFactory).getBytecode();
        _whiteListed.setInitHash(_initHash);
        _factory.setInitHash(_initHash);
        SetConditions _setconditions=new SetConditions{value:amount}(address(setup));
        vm.stopBroadcast();
    }
}


contract SetConditions{
    Setup setup;
    WhiteListed whiteListed;
    LamboToken lamboToken1;
    LamboToken lamboToken2;
    LamboToken lamboToken3;
    WETH9 wETH9;
    Balancer balancer;
    uint256 liquidityAmount = 32560203560896180352774;
    uint256 vETHBalanceTo_VETH_HBL=132534758877722247977 - (3.3 ether);
    uint256 vETHBalanceTo_VETH_CBO=5007791505809550535 - 0.05 ether;
    uint256 vETHBalanceTo_VETH_BIN=3852171628908871705- 3 ether;
    constructor(address _setup)payable{
        setup=Setup(_setup);
        whiteListed=setup.whilteListed();
        lamboToken1=setup.lamboToken1();
        lamboToken2=setup.lamboToken2();
        lamboToken3=setup.lamboToken3();
        wETH9=setup.wETH9();
        balancer=setup.balancer();
        wETH9.deposit{value: liquidityAmount}(address(this));
        wETH9.approve(address(balancer), liquidityAmount);
        balancer.provideLiquidity(address(wETH9), liquidityAmount);
        whiteListed.buyQuote{value: vETHBalanceTo_VETH_HBL}(address(lamboToken1), vETHBalanceTo_VETH_HBL, 0);
        whiteListed.buyQuote{value:vETHBalanceTo_VETH_CBO}(address(lamboToken2), vETHBalanceTo_VETH_CBO, 0);
        whiteListed.buyQuote{value: vETHBalanceTo_VETH_BIN}(address(lamboToken3), vETHBalanceTo_VETH_BIN, 0);
    }
    
}