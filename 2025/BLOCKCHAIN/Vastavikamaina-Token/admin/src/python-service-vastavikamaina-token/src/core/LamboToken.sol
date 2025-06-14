//SPDX-License-Identifier-MIT
pragma solidity ^0.8.20;


import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract LamboToken is ERC20{
    error LamboToken__Already__Initialized();
    uint256 public constant TOTAL_AMOUNT_OF_QUOTE_TOKEN=100_000_000 * 1e18;
    constructor(string memory _name,string memory _symbol)ERC20(_name,_symbol){
    }

    function initialize()public{
        if(totalSupply()>0){
            revert LamboToken__Already__Initialized();
        }
        _mint(msg.sender, TOTAL_AMOUNT_OF_QUOTE_TOKEN);
    }
}