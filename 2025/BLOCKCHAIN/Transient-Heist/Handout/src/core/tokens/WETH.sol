//SPDX-license-Identifier:MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract WETH is ERC20{

    /*//////////////////////////////////////////////////////////////
                                 ERRORS
    //////////////////////////////////////////////////////////////*/
    error WETH__Insufficient__WETH__To__Withdraw();
    error WETH__ETH__Transfer__Failed();
    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/

    event WETH__Mint(address _to,uint256 _amount);
    event WETH__Burn(address _from,uint256 _amount);

    constructor()ERC20("WETH","WETH"){

    }

    function deposit(address _receiver)public payable{
        uint256 mintAmount=msg.value;
        _mint(_receiver,mintAmount);
        emit WETH__Mint(_receiver,mintAmount);
    }


    function withdraw(uint256 _amount)public payable{
        if(balanceOf(msg.sender)<_amount){
            revert WETH__Insufficient__WETH__To__Withdraw();
        }
        address _from=msg.sender;
        _burn(_from, _amount);
        (bool success,)=_from.call{value:_amount}("");
        if(!success){
            revert WETH__ETH__Transfer__Failed();
        }
        emit WETH__Burn(_from,_amount);
    }
}