//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {DEX} from "./DEX.sol";
import {IERC20} from "@openzeppelin-contracts/token/ERC20/IERC20.sol";
import {Finance} from "./Finance.sol";
import {IERC20} from "@openzeppelin-contracts/token/ERC20/IERC20.sol";

/*
    @title:The Time Travellers DEX
    @author:s4bot3ur
 */

contract Setup{

    error Setup_Bonus_Already_Claimed();
    error Setup_Inelgible_For_Bonus_Claim();
    error Setup_Player_Already_Set();
    error Setup_Insufficient_WETH_To_Solve();
    error Setup_Insufficient_INR_To_Solve();
    error Setup_Insufficient_ETH_To_Solve();
    error Setup_Dex_Pool_Ratio_Changed();
    error Setup_Bonus_Cannot_Be_Claimed_During_Flash_Loan();
    error Setup_DEX_Swap_Count_Limit_Exceeds();
    
    bool public solved;
    DEX public dex;
    Finance public finance;
    address public player;
    uint16 public constant FLASH_LOAN_FEE=0;
    
    uint256 public constant WETH_SUPPLIED_BY_LP=50_000 ether;
    uint256 public constant INR_SUPPLIED_BY_LP=2_30_000 * WETH_SUPPLIED_BY_LP;
    uint256 public constant WETH_MAX_FLASH_LOAN=WETH_SUPPLIED_BY_LP;
    uint256 public constant INR_MAX_FLASH_LOAN=INR_SUPPLIED_BY_LP;
    address public WETH;
    address public INR;
    bool claimed1;
    bool claimed2;
    uint256 finance_ETH=250_000 ether;
    uint256 userBonus1=12_500 ether;
    uint256 userBonus2=10_000 ether;

    constructor() payable{
        uint256 _requiredETH=finance_ETH+userBonus1+userBonus2;
        require(msg.value >=_requiredETH);
        dex=new DEX();
        finance=new Finance{value: finance_ETH}(
            FLASH_LOAN_FEE,
            WETH_MAX_FLASH_LOAN,
            INR_MAX_FLASH_LOAN,
            address(dex)
        );
        WETH=address(finance.WETH());
        INR=address(finance.INR());
        dex.initialize(WETH, INR);
        finance.mint(WETH, address(this), WETH_SUPPLIED_BY_LP);
        finance.mint(INR,address(this),INR_SUPPLIED_BY_LP);
        IERC20(WETH).transfer(address(dex), WETH_SUPPLIED_BY_LP);
        IERC20(INR).transfer(address(dex), INR_SUPPLIED_BY_LP);
        dex.mint(address(this));
    }

    function setPlayer(address _player)external{
        if(player==address(0)){
            player=_player;
        }else{
            revert Setup_Player_Already_Set();
        }
    }

    function claimBonus1()external{
        if(claimed1){
            revert Setup_Bonus_Already_Claimed();
        }
        claimed1=true;
        payable(msg.sender).call{value: userBonus1}("");
    }

    function claimBonus2()external {
        if(claimed2){
            revert Setup_Bonus_Already_Claimed();
        }
        if(finance.entered()){
            revert Setup_Bonus_Cannot_Be_Claimed_During_Flash_Loan();
        }
        if(IERC20(WETH).balanceOf(msg.sender) <50_000 ether){
            revert Setup_Inelgible_For_Bonus_Claim();
        }
        claimed2=true;
        payable(msg.sender).call{value: userBonus2}("");
    }

    function solve()external{
        address _msgSender=msg.sender;
        if(IERC20(WETH).balanceOf(_msgSender)< 100_000 ether){
            revert Setup_Insufficient_WETH_To_Solve();
        }else if(IERC20(INR).balanceOf(_msgSender)< 2_30_000 * 100_000 ether ){
            revert Setup_Insufficient_INR_To_Solve();
        }else if(_msgSender.balance< 89_835 ether){
            revert Setup_Insufficient_ETH_To_Solve();
        }else if(dex.reserve0()<WETH_SUPPLIED_BY_LP || dex.reserve1()<INR_SUPPLIED_BY_LP){
            revert Setup_Dex_Pool_Ratio_Changed();
        }else if(dex.swaps_count()>uint256(6)){
            revert Setup_DEX_Swap_Count_Limit_Exceeds();
        }
        solved=true;
    }

    function isSolved()public view returns (bool){
        return solved;
    }
}