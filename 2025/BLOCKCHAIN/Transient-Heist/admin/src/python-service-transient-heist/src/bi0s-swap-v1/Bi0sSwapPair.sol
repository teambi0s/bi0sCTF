//SPDX-License-Identifier:MIT
pragma solidity 0.6.12;

import {console} from "forge-std/Test.sol";
import {ERC20} from "./contracts/token/ERC20/ERC20.sol";
import {IERC20} from "./contracts/token/ERC20/IERC20.sol";
import {Math} from "./libraries/Math.sol";
import {SafeMath} from "./contracts/math/SafeMath.sol";
import {IBi0sSwapCalle} from "./interfaces/IBi0sSwapCalle.sol";
contract Bi0sSwapPair is ERC20{

    using SafeMath for uint256;
    /*//////////////////////////////////////////////////////////////
                                 ERRORS
    //////////////////////////////////////////////////////////////*/

    address public token0;
    address public token1;
    uint256 public reserve0;
    uint256 public reserve1;
    address public factory;
    bool entered;
    constructor()ERC20("Bi0s-Swap-V1","bi0s") public{
        factory=msg.sender;
    }

    modifier nonReEntrant(){
        
        if(entered){
            revert("REENTRANCY PROHIBITED");
        }
        entered=true;
        _;
        entered=false;
    }

    function initialize(address _token0,address _token1)public{
        if(msg.sender!=factory){
            revert("Only Factory") ;
        }
        token0=_token0;
        token1=_token1;
    }



    function addLiquidity(address _receiver)public returns (uint256 liquidity){
        uint256 balance0=IERC20(token0).balanceOf(address(this));
        uint256 balance1=IERC20(token1).balanceOf(address(this));

        uint256 amountIn0;
        uint256 amountIn1;
        uint256 _totalSupply=totalSupply();
        if(_totalSupply==0){
            liquidity=Math.sqrt(balance0*balance1);
        }else{
            amountIn0=balance0.sub(reserve0);
            amountIn1=balance1.sub(reserve1);
            liquidity = Math.min(Math.mulDiv(amountIn0, _totalSupply, reserve0), Math.mulDiv(amountIn1, _totalSupply, reserve1));
        }
        _mint(_receiver,liquidity);
        _update();

    }

    function removeLiquidity(address _receiver) public {
        uint256 liquidity = balanceOf(address(this));
        uint256 _totalSupply = totalSupply();
        uint256 amount0 =Math.mulDiv(liquidity, reserve0, _totalSupply);
        uint256 amount1 = Math.mulDiv(liquidity, reserve1, _totalSupply);
        _burn(address(this), liquidity);
        IERC20(token0).transfer(_receiver, amount0);
        IERC20(token1).transfer(_receiver, amount1);
        _update();
    }



    function swap(address inputToken, uint256 inputAmount, address _receiver,bytes memory data) public nonReEntrant {
        if(inputToken != token0 && inputToken != token1){
            revert("Invalid Token In");
        }
        bool isToken0 = inputToken == token0;
        address outputToken = isToken0 ? token1 : token0;
        uint256 reserveIn = isToken0 ? reserve0 : reserve1;
        uint256 reserveOut = isToken0 ? reserve1 : reserve0;
        IERC20(inputToken).transferFrom(msg.sender, address(this), inputAmount);
        uint256 newReserveOut = Math.mulDiv(reserveIn, reserveOut, reserveIn + inputAmount);
        uint256 outputAmount = reserveOut - newReserveOut;
        if(outputAmount >= reserveOut) {
            revert("Insufficient liquidity");
        }
        IERC20(outputToken).transfer(_receiver, outputAmount);
        uint256 length;
        assembly{
            length:=extcodesize(_receiver)
        }
        if(data.length>0){
            IBi0sSwapCalle(_receiver).bi0sSwapv1Call(msg.sender,outputToken , outputAmount, data);
        }
        _update();
    }

    function getRequiredInputAmount(address tokenIn,uint256 desiredOutput) public returns (uint256 inputAmount) {
        uint256 reserveIn;
        uint256 reserveOut;
        if(tokenIn==token0){
            reserveIn=reserve0;
            reserveOut=reserve1;
        }else{
            reserveIn=reserve1;
            reserveOut=reserve0;
        }
        require(desiredOutput < reserveOut, "Output too large");
        inputAmount =Math.mulDiv(reserveIn, desiredOutput, reserveOut.sub(desiredOutput));
    }

    function getReserves() external view returns (uint256,uint256){
        return (reserve0,reserve1);
    }

    function _update()internal{
        reserve0=IERC20(token0).balanceOf(address(this));
        reserve1=IERC20(token1).balanceOf(address(this));
    }
}