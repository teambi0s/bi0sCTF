//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IDEX{
    function mint(address _to)external returns (uint256 liquidity);
    function burn(address _to)external returns (uint256,uint256);
    function swap(address _tokenIn,uint256 _amountIn,uint256 _minTokenOut,address _to)external returns (uint256);
}