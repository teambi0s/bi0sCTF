// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Stake} from "./Stake.sol";
import {INR} from "./INR.sol";

/*
 * @title:Empty-Vessel
 * @author:s4bot3ur
 */

contract Setup{
    
    error Setup_Already_Claimed();
    error Setup_Insufficient_Ether();
    error Setup__Chall__Unsolved();
    error Setup__Not__Yet__Staked();
    Stake public stake;
    INR public inr;
    bool public claimed;
    bool public solved;
    bool public staked;
    uint256 bonusAmount=1746230400;
    uint256 stakeAmount=100_000 ether;
    constructor(){
        inr=new INR(stakeAmount+bonusAmount,"INR","INR");
        stake=new Stake(inr,100_000 ether,100_000 ether);
    }

    function claim()external{
        if(claimed){
            revert Setup_Already_Claimed();
        }
        claimed=true;
        inr.transfer(msg.sender,bonusAmount);
    }

    function stakeINR()external{
        inr.approve(address(stake), stakeAmount);
        stake.deposit(stakeAmount , address(this));
        staked=true;
    }

    function solve()external{
        if(!staked){
            revert Setup__Not__Yet__Staked();
        }
        uint256 assetsReceived=stake.redeemAll(address(this),address(this));
        if(assetsReceived>75_000 ether){
            revert Setup__Chall__Unsolved();
        }
        solved=true;
    }

    function isSolved()public view returns (bool){
        return solved;
    }
}
