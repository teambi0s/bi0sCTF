//SPDX-License-Identifier-MIT
pragma solidity >=0.6.12;


interface IBi0sSwapFactory{
    function createPair(address tokenA, address tokenB) external returns (address pair);

    function getBytecode()external returns(bytes32);

    function getPair(address tokenA, address tokenB) external view returns (address pair);

}