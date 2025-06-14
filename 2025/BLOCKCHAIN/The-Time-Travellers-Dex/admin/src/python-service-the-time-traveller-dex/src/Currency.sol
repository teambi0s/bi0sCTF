//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin-contracts/token/ERC20/ERC20.sol";

contract Currency is ERC20{

    /*//////////////////////////////////////////////////////////////
                                 ERRORS
    //////////////////////////////////////////////////////////////*/

    error Currency_Unauthorized_Account(address _caller,address _expected_Caller);

    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/

    event minted(address indexed _to,uint256 indexed _value);
    event burnt(address indexed _from,uint256 indexed _value);



    address immutable Finance;
    
    constructor(string memory _name,string memory _symbol)ERC20(_name,_symbol){
        Finance=msg.sender;
    }

    /*//////////////////////////////////////////////////////////////
                           FINANCE CONTROLLED
    //////////////////////////////////////////////////////////////*/

    modifier onlyFinance(){
        if(msg.sender!=Finance){
            revert Currency_Unauthorized_Account(msg.sender,Finance);
        }
        _;
    }

    function mint(address _to,uint256 _value)external onlyFinance{
        _mint(_to, _value);
        emit minted(_to,_value);
    }

    function burn(address _from,uint256 _value)external onlyFinance{
        _burn(_from, _value);
        emit burnt(_from,_value);
    }
}