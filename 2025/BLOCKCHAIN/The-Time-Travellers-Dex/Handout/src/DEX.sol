//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Ownable} from "@openzeppelin-contracts/access/Ownable.sol";
import {IERC20} from "@openzeppelin-contracts/token/ERC20/IERC20.sol";
import {UQ112x112} from "./libraries/UQ112x112.sol";
import {ERC20} from "@openzeppelin-contracts/token/ERC20/ERC20.sol";
import {Math} from "./libraries/Math.sol";
import {console} from "forge-std/Test.sol";
contract DEX is Ownable,ERC20("LPTOKEN","LPT") {
    using UQ112x112 for uint224;
    /*//////////////////////////////////////////////////////////////
                                 ERRORS
    //////////////////////////////////////////////////////////////*/

    error DEX_Inavlid_Tokens(address _tokenIn,address _token0,address _token1);
    error DEX_Already_Initialized();
    error DEX_Insufficient_Tokens_In(uint256 _balanceIn);
    error DEX_Zero_Address();
    error DEX_Invalid_Amount_In(uint256 _tokensIn,uint256 _expectedTokensIn);
    error DEX_Invalid_Liquidity(uint256 _liquidity);
    error DEX_Core_Invariant_Changed();
    error DEX_Swap_Amount_Limit_Reached(uint256 _actualLimit,uint256 _swapAmount);
    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/

    event Initialized();

    /*//////////////////////////////////////////////////////////////
                            STATE VARIABLES
    //////////////////////////////////////////////////////////////*/
    uint16 public constant MAX_PERCENT=10000; // 100%
    uint16 public constant LP_FEE_MAX_PERCENT=1000; //10%
    uint16 public LP_FEE;
    bool initialized;
    address public fee_receiver;
    address public token0;
    address public token1;
    uint112 public reserve0;
    uint112 public reserve1;
    uint256 public price0CumulativeLast;
    uint256 public price1CumulativeLast;
    uint256 public timeStampLast;
    uint256 public swaps_count;
    uint256 public max_Swap_Token0;
    uint256 public max_Swap_Token1;
    constructor()Ownable(msg.sender){
    }

    /*//////////////////////////////////////////////////////////////
                            OWNER RESTRICTED
    //////////////////////////////////////////////////////////////*/

    function initialize(address _token0,address _token1)external onlyOwner{
        if(initialized){
            revert DEX_Already_Initialized();
        }
        initialized=true;
        token0=_token0;
        token1=_token1;
        emit Initialized();
    }

    function set_LP_Fee(uint16 _lp_FEE)external onlyOwner{
        LP_FEE=_lp_FEE;
    } 


    /*//////////////////////////////////////////////////////////////
                                GETTERS
    //////////////////////////////////////////////////////////////*/

    function _get_reserves(address _tokenIn)internal view returns (uint112,uint112){
        if(_tokenIn==token0){
            return (reserve0,reserve1);
        }
        return (reserve1,reserve0);
    }

    function get_Cumulative_Prices()external view returns (uint256,uint256,uint256){
        return (price0CumulativeLast,price1CumulativeLast,timeStampLast);
    }


    function _update() private {
        reserve0=uint112(IERC20(token0).balanceOf(address(this)));
        reserve1=uint112(IERC20(token1).balanceOf(address(this)));
        uint256 timeElapsed=block.timestamp-timeStampLast;

        if(timeElapsed>0 && reserve0>0 && reserve1>0){
            price0CumulativeLast+=uint256(UQ112x112.encode(reserve1).uqdiv(reserve0)*timeElapsed);
            price1CumulativeLast+=uint256(UQ112x112.encode(reserve0).uqdiv(reserve1)*timeElapsed);
        }
        timeStampLast=block.timestamp;

    }

    function getSwapInfo(address _tokenIn,uint256 _amountIn)external view returns(uint256 _tokensOut,uint256 _tokensInIncludingFee){
        if((_tokenIn !=token0 && _tokenIn !=token1)){
            revert DEX_Inavlid_Tokens(_tokenIn,token0,token1);
        }
        (uint112 _reservesIn,uint112 _reservesOut)=_get_reserves(_tokenIn);

        if(_tokenIn==token0){
            _tokensInIncludingFee= (_amountIn+(_amountIn*LP_FEE /MAX_PERCENT));     
            _tokensOut= _reservesOut- ((uint256(_reservesIn) *uint256( _reservesOut))/(_reservesIn+_amountIn));
        }else{
            _tokensInIncludingFee= (_amountIn+(_amountIn*LP_FEE /MAX_PERCENT));
            _tokensOut= _reservesOut- ((uint256(_reservesIn) *uint256( _reservesOut))/(_reservesIn+_amountIn));
        }
    }

    /*//////////////////////////////////////////////////////////////
                                  CORE
    //////////////////////////////////////////////////////////////*/


    function mint(address _to)external returns (uint256 liquidity){
       (uint112 _reserve0, uint112 _reserve1) = _get_reserves(token0); 
        uint256 _balance0 = IERC20(token0).balanceOf(address(this));
        uint256 _balance1 = IERC20(token1).balanceOf(address(this));

        uint256 _token0Deposited=_balance0-reserve0;
        uint256 _token1Deposited=_balance1-reserve1;
        uint256 _total_supply=totalSupply();
        if(_total_supply ==0 ){
            liquidity=Math.sqrt(_token0Deposited * _token1Deposited);
            max_Swap_Token0=_balance0;
            max_Swap_Token1=_balance1;
        }
        else{
            liquidity = Math.min((_token0Deposited * _total_supply) / _reserve0, (_token1Deposited*_total_supply )/ _reserve1);
        }

        if(liquidity<=0){
            revert DEX_Invalid_Liquidity(liquidity);
        }
        _mint(_to, liquidity);
        _update();

    }

    function burn(address _to)external returns (uint256,uint256){
        uint256 _liquidity=balanceOf(address(this));
        uint256 _total_supply=totalSupply();
        uint256 _amount0=_liquidity* IERC20(token0).balanceOf(address(this))/_total_supply;
        uint256 _amount1=_liquidity* IERC20(token1).balanceOf(address(this))/_total_supply;
        IERC20(token0).transfer(_to, _amount0);
        IERC20(token1).transfer(_to, _amount1);
        _burn(address(this), _liquidity);
        _update();
        return (_amount0,_amount1);
    }       

    function swap(address _tokenIn,uint256 _amountIn,uint256 _minTokenOut,address _to)external returns (uint256){
        swaps_count++;
        if((_tokenIn !=token0 && _tokenIn !=token1)){
            revert DEX_Inavlid_Tokens(_tokenIn,token0,token1);
        }

        (uint112 _reservesIn,uint112 _reservesOut)=_get_reserves(_tokenIn);
         /*
        x*y <= (x+dx)*(y-dy)
        (x*y)/(x+dx)<=y-dy
        dy<=y- (x*y)/(x+dx)
        */
        uint256 _balance0=IERC20(token0).balanceOf(address(this));
        uint256 _balance1=IERC20(token1).balanceOf(address(this));
        uint256 _tokensOut;
        if(_tokenIn==token0){
            if(_amountIn>max_Swap_Token0){
                revert DEX_Swap_Amount_Limit_Reached(max_Swap_Token0,_amountIn);
            }
            uint256 _balanceIn=_balance0-reserve0;
            uint256 _fee=_amountIn*LP_FEE /MAX_PERCENT;
            uint256 _expected_TokensIn= _amountIn;
            if(_balanceIn<_expected_TokensIn){
                revert DEX_Invalid_Amount_In(_balanceIn,_expected_TokensIn);
            }

            _tokensOut= ((uint256(_reservesOut)*1e20)- ((uint256(_reservesIn) *uint256( _reservesOut)*1e20)/(_reservesIn+_balanceIn-_fee)))/1e20;
            if(_tokensOut<_minTokenOut){
                revert DEX_Insufficient_Tokens_In(_balanceIn);
            }

            IERC20(token1).transfer(_to, _tokensOut);
        
        }else{
            if(_amountIn>max_Swap_Token1){
                revert DEX_Swap_Amount_Limit_Reached(max_Swap_Token1,_amountIn);
            }
            uint256 _balanceIn=_balance1-reserve1;
            uint256 _fee=_amountIn*LP_FEE /MAX_PERCENT;
            uint256 _expected_TokensIn= _amountIn;
            if(_balanceIn<_expected_TokensIn){
                revert DEX_Invalid_Amount_In(_balanceIn,_expected_TokensIn);
            }
            _tokensOut= ((uint256(_reservesOut)*1e20)- ((uint256(_reservesIn) *uint256( _reservesOut)*1e20)/(_reservesIn+_balanceIn-_fee)))/1e20;
            if(_tokensOut<_minTokenOut){
                revert DEX_Insufficient_Tokens_In(_balanceIn);
            }
            IERC20(token0).transfer(_to, _tokensOut);
        }
        _update();
        if(!(uint256(reserve0)*uint256(reserve1)>=uint256(_reservesIn)*uint256(_reservesOut))){
            revert DEX_Core_Invariant_Changed();
        }
        return _tokensOut;
    }

    ///@notice This challenge had an unintended solution because the second line mistakenly used `token0` for the transfer instead of `token1`. 
    /*
    function skim(address _to) external  {
        IERC20(token0).transfer(_to, IERC20(token0).balanceOf(address(this))-reserve0);
        IERC20(token0).transfer(_to, IERC20(token1).balanceOf(address(this))-reserve1);
    }*/

    function skim(address _to) external  {
        IERC20(token0).transfer(_to, IERC20(token0).balanceOf(address(this))-reserve0);
        IERC20(token1).transfer(_to, IERC20(token1).balanceOf(address(this))-reserve1);
    }


    function sync()external{
        _update();
    }

}