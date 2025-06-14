//SPDX-License-Identifier:MIT
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {USDS} from "./tokens/USDS.sol";

import {IBi0sSwapFactory} from "src/bi0s-swap-v1/interfaces/IBi0sSwapFactory.sol";
import {IBi0sSwapPair} from "src/bi0s-swap-v1/interfaces/IBi0sSwapPair.sol";
import {IBi0sSwapCalle} from "src/bi0s-swap-v1/interfaces/IBi0sSwapCalle.sol";

/*
 T *his contract only accepts Safe Moon,WETH,SOL
 1WETH     =2500USDS
 1SafeMoon =0.0000000000001657 USDS
 1SOL      =150 USDS
 */


contract USDSEngine is IBi0sSwapCalle{
    /*//////////////////////////////////////////////////////////////
    ERRORS
    //////////////////////////////////////////////////////////////*/
    error USDSEngine_In_Equal_Lengths(uint8 _leftLength,uint8 _rightLength);
    error USDSEngine_Invalid_DepositToken(address _tokenAddress);
    error USDSEngine__Insufficient__Collateral();
    error USDSEngine__Insufficient__Collateral__To__Redeem();
    error USDSEngine__HealthFactor__Broken();
    error USDSEngine__ReEntrancy__Prohibited();
    error USDSEngine__Only__bi0sSwapPair__Can__Call();
    error USDSEngine__Insufficient__USDS__To__Burn();
    error USDSEngine__Insufficient__Tokens__In__Vault();
    /*//////////////////////////////////////////////////////////////
    EVENTS
    //////////////////////////////////////////////////////////////*/



    /*//////////////////////////////////////////////////////////////
    STATE VARIABLES
    //////////////////////////////////////////////////////////////*/
    uint8 constant LIQUIDATION_THRESHOLD=90;
    uint8 constant LIQUIDATION_PRECISION = 100;
    mapping(address token_address=>bool status) public accepted_tokens;
    mapping(address user=> mapping(address token=> uint256 amount)) public collateralDeposited;
    mapping(address user=> mapping(address token=> uint256 amount)) public user_vault;
    mapping(address user=> uint256 totalUSDS) public mintedUSDS;
    address[] public collateralTokens;
    USDS usds;
    IBi0sSwapFactory bi0sSwapFactory;

    address immutable USDC;


    constructor(address[] memory _tokenaddresses,bool[] memory _statuses,IBi0sSwapFactory _bi0sSwapFactory,address usdc){
        if(_tokenaddresses.length!=_statuses.length){
            revert USDSEngine_In_Equal_Lengths(uint8(_tokenaddresses.length),uint8(_statuses.length));
        }
        for(uint8 i=0;i<_statuses.length;i++){
            accepted_tokens[_tokenaddresses[i]]=_statuses[i];
            collateralTokens.push(_tokenaddresses[i]);
        }
        bi0sSwapFactory=_bi0sSwapFactory;
        USDC=usdc;
    }

    modifier acceptedToken(address _tokenAddress){
        if(!accepted_tokens[_tokenAddress]){
            revert USDSEngine_Invalid_DepositToken(_tokenAddress);
        }
        _;
    }

    modifier nonReEntrant(){
        bool entered;
        assembly{
            entered:=tload(0)
        }
        if(entered){
            revert USDSEngine__ReEntrancy__Prohibited();
        }
        assembly{
            tstore(0,1)
        }
        _;
        assembly{
            tstore(0,0)
        }
    }


    function depositCollateralAndMint(address _tokenAddress,uint256 _amountCollateral,uint256 _usdsMintAmount)public acceptedToken(_tokenAddress){
        uint256 max_usds_mint=getUSDSMaxMintAmount(_tokenAddress, _amountCollateral);
        _validateMintAmount(_usdsMintAmount,max_usds_mint);
        IERC20(_tokenAddress).transferFrom(msg.sender, address(this), _amountCollateral);
        collateralDeposited[msg.sender][_tokenAddress]=_usdsMintAmount;
        _mintUSDS(msg.sender,_usdsMintAmount);
    }

    function depositCollateralThroughSwap(address _otherToken,address _collateralToken,uint256 swapAmount,uint256 _collateralDepositAmount)public acceptedToken(_otherToken)returns (uint256 tokensSentToUserVault){
        IERC20(_otherToken).transferFrom(msg.sender, address(this), swapAmount);
        IBi0sSwapPair bi0sSwapPair=IBi0sSwapPair(bi0sSwapFactory.getPair(_otherToken, _collateralToken));
        assembly{
            tstore(1,bi0sSwapPair)
        }
        bytes memory data=abi.encode(_collateralDepositAmount);
        IERC20(_otherToken).approve(address(bi0sSwapPair), swapAmount);
        bi0sSwapPair.swap(_otherToken, swapAmount, address(this),data);
        assembly{
            tokensSentToUserVault:=tload(1)
        }
    }

    function redeemCollateral(address _tokenAddress,uint256 _redeemAmount)public acceptedToken(_tokenAddress){
        uint256 tokenCollateralDeposited=collateralDeposited[msg.sender][_tokenAddress];

        if(tokenCollateralDeposited<_redeemAmount){
            revert USDSEngine__Insufficient__Collateral__To__Redeem();
        }

        collateralDeposited[msg.sender][_tokenAddress]-=_redeemAmount;

        uint256 current_user_collateral_value_in_usds=getAccountData(msg.sender);

        if(current_user_collateral_value_in_usds<mintedUSDS[msg.sender]){
            revert USDSEngine__HealthFactor__Broken();
        }
    }

    function bi0sSwapv1Call(address sender,address collateralToken,uint256 amountOut,bytes memory data) external nonReEntrant {
        uint256 collateralDepositAmount=abi.decode(data,(uint256));
        address bi0sSwapPair;
        assembly{
            bi0sSwapPair:=tload(1)
        }
        if(msg.sender!=bi0sSwapPair){
            revert USDSEngine__Only__bi0sSwapPair__Can__Call();
        }
        if(collateralDepositAmount>amountOut){
            revert USDSEngine__Insufficient__Collateral();
        }
        uint256 tokensSentToUserVault=amountOut-collateralDepositAmount;
        user_vault[sender][collateralToken]+=tokensSentToUserVault;
        assembly{
            tstore(1,tokensSentToUserVault)
        }
        collateralDeposited[sender][collateralToken]+=collateralDepositAmount;
    }

    function mintUSDS(uint256 _amount)public{
        uint256 current_user_collateral_value_in_usds=getAccountData(msg.sender);
        uint256 max_allowed=(current_user_collateral_value_in_usds*LIQUIDATION_THRESHOLD)/LIQUIDATION_PRECISION;
        if(_amount> max_allowed){
            revert USDSEngine__HealthFactor__Broken();
        }
        _mintUSDS(msg.sender,_amount);
        mintedUSDS[msg.sender]+=_amount;

    }

    function burnUSDS(uint256 _amount)public{
        uint256 usdsMinted=mintedUSDS[msg.sender];
        if(usdsMinted<_amount){
            revert USDSEngine__Insufficient__USDS__To__Burn();
        }
        usds.burn(msg.sender, _amount);
    }

    function getUSDSMaxMintAmount(address _tokenAddress,uint256 _amountCollateral)public view returns (uint256 max_usds_mint){
        IBi0sSwapPair uniPair=IBi0sSwapPair(bi0sSwapFactory.getPair(USDC, _tokenAddress));
        (uint256 _reserve0,uint256 _reserve1)=uniPair.getReserves();
        uint256 _deposit_Token_Price_in_usds;
        if(uniPair.token0()==USDC){
            _deposit_Token_Price_in_usds=(_reserve0*1e25)/(_reserve1);
        }else{

            _deposit_Token_Price_in_usds=(_reserve1*1e25)/(_reserve0);
        }

        max_usds_mint = (_amountCollateral *_deposit_Token_Price_in_usds)/1e25;
        max_usds_mint=(max_usds_mint*LIQUIDATION_THRESHOLD)/LIQUIDATION_PRECISION;
    }

    function convert_Tokens_From_Vault_To_Deposits(address _tokenAddress,uint256 _amount)public acceptedToken(_tokenAddress){
        uint256 _userVaultBalance=user_vault[msg.sender][_tokenAddress];
        if(_amount>_userVaultBalance){
            revert USDSEngine__Insufficient__Tokens__In__Vault();
        }
        user_vault[msg.sender][_tokenAddress]-=_amount;
        collateralDeposited[msg.sender][_tokenAddress]+=_amount;
    }

    function _validateMintAmount(uint256 _usdsMintAmount,uint256 _max_usds_mint)internal pure{
        if(_usdsMintAmount>_max_usds_mint){
            revert USDSEngine__Insufficient__Collateral();
        }
    }

    function _mintUSDS(address _to,uint256 _amount)internal{
        usds.mint(_to, _amount);
    }

    function getAccountData(address _user)public view returns (uint256){
        uint256 collateral_value_in_usd;
        for(uint8 i=0;i<collateralTokens.length;i++){
            address _tokenAddress=collateralTokens[i];
            uint256 _amountDeposited=collateralDeposited[_user][_tokenAddress];
            if(_amountDeposited>0){
                collateral_value_in_usd+=getUSDSMaxMintAmount(_tokenAddress,_amountDeposited);
            }
        }
    }



}
