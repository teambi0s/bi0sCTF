//SPDX-License-Idenifier:MIT
pragma solidity ^0.8.20;

import {IBi0sSwapFactory} from "src/bi0s-swap-v1/interfaces/IBi0sSwapFactory.sol";
import {IBi0sSwapPair} from "src/bi0s-swap-v1/interfaces/IBi0sSwapPair.sol";
import {USDS} from "./tokens/USDS.sol";
import {USDC} from "./tokens/USDC.sol";
import {SafeMoon} from "./tokens/SafeMoon.sol";
import {WETH} from "./tokens/WETH.sol";
import {USDSEngine} from "./USDSEngine.sol";

interface IUniswapPoolsDeployHelper{
    function usdsUsdcPair()external view returns(IBi0sSwapPair);
    function usdsSafeMoonPair()external view returns(IBi0sSwapPair);
    function usdsWethPair()external view returns(IBi0sSwapPair);
    function wethUsdcPair()external view returns(IBi0sSwapPair);
    function wethSafeMoonPair()external view returns(IBi0sSwapPair);
    function safeMoonUsdcPair()external view returns(IBi0sSwapPair);
}

contract Setup{
    

    /*//////////////////////////////////////////////////////////////
                                 ERRORS
    //////////////////////////////////////////////////////////////*/

    error Setup__Already__Initialized();
    error Setup__Incorrect__ETH__Sent();

    address player;
    IBi0sSwapFactory public bi0sSwapFactory;
    uint256 public constant USDS_INITIAL_LIQUIDITY=0;
    uint256 public constant WETH_INITIAL_LIQUIDITY=2e18;
    uint256 public constant USDC_INITIAL_LIQUIDITY=WETH_INITIAL_LIQUIDITY*2500;
    uint256 public constant SAFEMOON_INITIAL_LIQUIDITY=(WETH_INITIAL_LIQUIDITY*15087507543753773); //safe moon price in weth is 150875075.43753773
    uint256 public constant WETH_SECOND_LIQUIDITY=225539152795198000*2e18-WETH_INITIAL_LIQUIDITY;
    uint256 public constant USDC_SECOND_LIQUIDITY=WETH_SECOND_LIQUIDITY*2500;
    uint256 public constant SAFEMOON_SECOND_LIQUIDITY=(WETH_SECOND_LIQUIDITY*15087507543753773); //safe moon price in weth is 150875075.43753773
    uint256 constant TOTAL_WETH_MINT=WETH_INITIAL_LIQUIDITY+WETH_SECOND_LIQUIDITY;
    uint256 constant TOTAL_USDC_MINT=USDC_INITIAL_LIQUIDITY+USDC_SECOND_LIQUIDITY;
    uint256 constant TOTAL_SAFEMOON_MINT=SAFEMOON_INITIAL_LIQUIDITY+SAFEMOON_SECOND_LIQUIDITY;

    USDS public usds;
    USDC public usdc;
    SafeMoon public safeMoon;
    WETH public weth;

    IBi0sSwapPair public wethUsdcPair;
    IBi0sSwapPair public wethSafeMoonPair;
    IBi0sSwapPair public safeMoonUsdcPair;

    IUniswapPoolsDeployHelper public poolDeployHelper;
    USDSEngine public usdsEngine;
    bool public initialized;

    constructor()payable{
        if(msg.value<TOTAL_WETH_MINT){
            revert Setup__Incorrect__ETH__Sent();
        }
        usds=new USDS(USDS_INITIAL_LIQUIDITY);
        usdc=new USDC(TOTAL_USDC_MINT);
        safeMoon=new SafeMoon(TOTAL_SAFEMOON_MINT);
        weth=new WETH();
    }

    function initialize(address _poolDeployHelper,address _bi0sSwapFactory)public{
        bi0sSwapFactory=IBi0sSwapFactory(_bi0sSwapFactory);
        if(initialized){
            revert Setup__Already__Initialized();
        }
        address[] memory _tokenaddresses=new address[](2);
        _tokenaddresses[0]=address(weth);
        _tokenaddresses[1]=address(safeMoon);
        bool[] memory _statuses=new bool[](2);
        _statuses[0]=true;
        _statuses[1]=true;
        
        usdsEngine=new USDSEngine(_tokenaddresses,_statuses,bi0sSwapFactory,address(usdc));
        usdsEngine.changeOtherTokenStatus(address(weth), true);
        usdsEngine.changeOtherTokenStatus(address(safeMoon), true);
        usdsEngine.changeOtherTokenStatus(address(usdc), true);
        usds.setMintAuthority(address(usdsEngine));
        poolDeployHelper=IUniswapPoolsDeployHelper(_poolDeployHelper);

        wethUsdcPair=poolDeployHelper.wethUsdcPair();
        wethSafeMoonPair=poolDeployHelper.wethSafeMoonPair();
        safeMoonUsdcPair=poolDeployHelper.safeMoonUsdcPair();

        weth.deposit{value:WETH_INITIAL_LIQUIDITY/2}(address(wethUsdcPair));
        usdc.transfer(address(wethUsdcPair), USDC_INITIAL_LIQUIDITY/2);
        wethUsdcPair.addLiquidity(address(this));

        weth.deposit{value:WETH_SECOND_LIQUIDITY/2}(address(wethUsdcPair));
        usdc.transfer(address(wethUsdcPair), USDC_SECOND_LIQUIDITY/2);
        wethUsdcPair.addLiquidity(address(this));

        weth.deposit{value:WETH_INITIAL_LIQUIDITY/2}(address(wethSafeMoonPair));
        safeMoon.transfer(address(wethSafeMoonPair),SAFEMOON_INITIAL_LIQUIDITY/2);
        wethSafeMoonPair.addLiquidity(address(this));

        weth.deposit{value:WETH_SECOND_LIQUIDITY/2}(address(wethSafeMoonPair));
        safeMoon.transfer(address(wethSafeMoonPair),SAFEMOON_SECOND_LIQUIDITY/2);
        wethSafeMoonPair.addLiquidity(address(this));

        usdc.transfer(address(safeMoonUsdcPair), USDC_INITIAL_LIQUIDITY/2);
        safeMoon.transfer(address(safeMoonUsdcPair), SAFEMOON_INITIAL_LIQUIDITY/2);
        safeMoonUsdcPair.addLiquidity(address(this));

        usdc.transfer(address(safeMoonUsdcPair), USDC_SECOND_LIQUIDITY/2);
        safeMoon.transfer(address(safeMoonUsdcPair), SAFEMOON_SECOND_LIQUIDITY/2);
        safeMoonUsdcPair.addLiquidity(address(this));
    }

    function setPlayer(address _player)public{
        player=_player;
    }


    function isSolved()public view returns (bool){
        bytes32 FLAG_HASH=keccak256("YOU NEED SOME BUCKS TO GET FLAG");
        bool check1;
        bool check2;
        if(usdsEngine.collateralDeposited(player,usdsEngine.collateralTokens(0))>uint256(FLAG_HASH)){
            check1=true;
        }
        if(usdsEngine.collateralDeposited(player,usdsEngine.collateralTokens(1))>uint256(FLAG_HASH)){
            check2=true;
        }
        return (check1&&check2);
    }
}