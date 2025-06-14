//SPDX-License-Identifier:MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract USDS is ERC20{
    /*//////////////////////////////////////////////////////////////
                                 ERRORS
    //////////////////////////////////////////////////////////////*/
    error USDS__Invalid__Authority();
    error USDS__Mint__Authority__Already__Initialized();
    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/
    event Mint(address indexed _to,uint256 indexed _amount);
    event Burn(address indexed _from,uint256 indexed _amount);

    /*//////////////////////////////////////////////////////////////
                            STATE VARIABLES
    //////////////////////////////////////////////////////////////*/
    address public mintAuthority;
    constructor(uint256 _initialSupply)ERC20("INR","INR"){
        _mint(msg.sender,_initialSupply);
    }

    function setMintAuthority(address _mintAuthority)public{
        if(mintAuthority==address(0)){
            mintAuthority=_mintAuthority;
        }else{
            revert USDS__Mint__Authority__Already__Initialized();
        }
    }

    /*//////////////////////////////////////////////////////////////
                            PUBLIC FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function mint(address _to,uint256 _value)public{
        if(msg.sender!=mintAuthority){
            revert USDS__Invalid__Authority();
        }
        _mint(_to, _value);
        emit Mint(_to,_value);
    }

    function burn(address _from,uint256 _value)public{
        if(msg.sender!=mintAuthority){
            revert USDS__Invalid__Authority();
        }
        _burn(_from, _value);
        emit Burn(_from,_value);
    }
}