// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {INR} from "./INR.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IERC4626} from "@openzeppelin/contracts/interfaces/IERC4626.sol";

contract Stake is Ownable,IERC4626,ERC20("INR VAULT","vINR"){

    error Stake_Zero_Shares();
    error Stake_Insufficient_Shares();
    error Stake_Not_An_Owner();
    error Stake_Assets_Exceeds_Max_Deposit_Limit();
    error Stake_Zero_Assets();

    INR inr;
    uint256 MAX_DEPOSIT;
    uint256 MAX_MINT;
    mapping(address depositer=> uint256 deposit) public deposits;

    constructor(INR _inr,uint256 _maxDeposit,uint256 _maxMint)Ownable(msg.sender) {
        inr=_inr;
        MAX_DEPOSIT=_maxDeposit;
        MAX_MINT=_maxMint;
    }

    function asset() external view returns (address assetTokenAddress){
        assetTokenAddress=address(inr);
    }

    function totalAssets() public view returns (uint256 totalManagedAssets){
        totalManagedAssets=inr.balanceOf(address(this));
    }
    
    function convertToShares(uint256 assets) public view returns (uint256 shares){
        if(totalSupply()==0){
            shares=assets;
        }else{
            shares= assets * totalSupply() / totalAssets();
        }

        
    }

    function convertToAssets(uint256 shares) public view returns (uint256 assets){
        if(shares==0){
            return 0;
        }
        assets= shares * totalAssets() / totalSupply();
    }

    function maxDeposit(address receiver) public view returns (uint256 maxAssets){
        maxAssets=MAX_DEPOSIT-deposits[receiver];
    }
    
    function previewDeposit(uint256 assets) external view returns (uint256 shares){
        shares=convertToShares(assets);
    }

    function deposit(uint256 assets, address receiver) external returns (uint256){
        if(assets>maxDeposit(msg.sender)){
            revert Stake_Assets_Exceeds_Max_Deposit_Limit();
        }
        uint256 shares=convertToShares(assets);
        if(shares ==0){
            revert Stake_Zero_Shares();
        }
        deposits[msg.sender]+=assets;
        inr.transferFrom(msg.sender,address(this),assets);
        _mint(receiver,shares);

        emit Deposit(msg.sender,receiver,assets,shares);
        return shares;
    }

    function maxMint(address receiver) external view returns (uint256 maxShares){
        maxShares= MAX_MINT-balanceOf(receiver);
    }

    function previewMint(uint256 shares) external view returns (uint256 assets){
        assets= convertToAssets(shares);
    }

    function mint(uint256 shares, address receiver) external returns (uint256 assets){
        if(shares ==0){
            revert Stake_Zero_Shares();
        }
        assets= convertToAssets(shares);
        if(assets>maxDeposit(msg.sender)){
            revert Stake_Assets_Exceeds_Max_Deposit_Limit();
        }
        deposits[msg.sender]+=assets;
        inr.transferFrom(msg.sender,address(this),assets);
        _mint(receiver,shares);

        emit Deposit(msg.sender,receiver,assets,shares); 
        return assets;
    }
    
    function maxWithdraw(address owner) external view returns (uint256 maxAssets){
        uint256 shares=balanceOf(owner);
        maxAssets=convertToAssets(shares);
    }

    function previewWithdraw(uint256 assets) external view returns (uint256 shares){
        shares=convertToShares(assets);
    }

    function withdraw(uint256 assets, address receiver, address owner) external returns (uint256 shares){
        if(assets==0){
            revert Stake_Zero_Assets();
        }
        if(msg.sender!=owner){
            revert Stake_Not_An_Owner();
        }
        shares=convertToShares(assets);
        if (shares==0){
            revert Stake_Zero_Shares();
        }else if(shares > balanceOf(owner)){
            revert Stake_Insufficient_Shares();
        }
        _burn(owner, shares);
        deposits[msg.sender]-=assets;
        inr.transfer(receiver, assets);
    }

    function maxRedeem(address owner) external view returns (uint256 maxShares){
        return balanceOf(owner);
    }

    function previewRedeem(uint256 shares) external view returns (uint256 assets){
        assets=convertToAssets(shares);
    }

    function redeem(uint256 shares, address receiver, address owner) external returns (uint256 assets){
        if(msg.sender!=owner){
            revert Stake_Not_An_Owner();
        }
        if(shares > balanceOf(owner)){
            revert Stake_Insufficient_Shares();
        }
        assets=convertToAssets(shares);
        if(assets==0){
            revert Stake_Zero_Assets();
        }
        _burn(owner, shares);
        deposits[msg.sender]-=assets;
        inr.transfer(receiver, assets);
    }

    function previewMaxRedeem()external view returns (uint256 assets){
        uint256 shares=balanceOf(msg.sender);
        assets=convertToAssets(shares);
    }

    function redeemAll(address receiver,address owner)external returns(uint256 assets){
        if(msg.sender!=owner){
            revert Stake_Not_An_Owner();
        }
        uint256 shares=balanceOf(owner);
        assets=convertToAssets(shares);
        _burn(owner, shares);
        deposits[owner]=0;
        inr.transfer(receiver, assets);
    }


}