//SPDX-License-Identifier:MIT
pragma solidity >=0.6.12;

interface IBi0sSwapPair{

    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint256,uint256);
    function addLiquidity(address _receiver)external returns (uint256 liquidity);
    function removeLiquidity(address _receiver) external;
    function swap(address inputToken, uint256 inputAmount, address _receiver,bytes memory data) external;
    function getRequiredInputAmount(address tokenIn,uint256 amountOut)external returns (uint256);
    function reserve0() external view returns (uint256);
    function reserve1() external view returns (uint256);
    function mulandDiv(uint256 a,uint256 b,uint256 denominator)external returns (uint256);
}