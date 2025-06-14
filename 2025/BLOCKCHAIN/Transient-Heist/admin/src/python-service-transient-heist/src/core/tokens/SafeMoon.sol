//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SafeMoon is ERC20{
    
    constructor(uint256 _initialSupply)ERC20("SAFE MOON","SFM"){
        _mint(msg.sender, _initialSupply);
    }
}