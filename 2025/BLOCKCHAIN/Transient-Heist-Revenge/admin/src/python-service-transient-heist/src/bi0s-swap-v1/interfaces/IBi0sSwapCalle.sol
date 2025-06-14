pragma solidity >=0.6.12;

interface IBi0sSwapCalle {
    function bi0sSwapv1Call(address sender,address outputToken,uint256 amountOut,bytes memory data) external;
}
