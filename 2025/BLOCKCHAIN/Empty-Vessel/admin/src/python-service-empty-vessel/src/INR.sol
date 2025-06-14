// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {console} from "forge-std/Test.sol";

contract INR {
    error InsufficientBalance(uint256 _actualBalance,uint256 _expectedAmount);
    error InsufficientAllowance(uint256,uint256);
    error Invalid_Length(uint256,uint256);
    error INR__Zero__Balance();
    error OwnableUnauthorizedAccount(address);
    
    constructor(uint256 initalSupply,string memory name,string memory symbol){
        assembly{
            let ptr:=mload(0x40)
            if gt(mload(name),0x20){
                mstore(add(ptr,0x20),0xc4609c1e)
                mstore(add(ptr,0x40),0x20)
                mstore(add(ptr,0x60),mload(name))
                revert(add(add(ptr,0x20),0x1c),0x44)
            }

            if gt(mload(symbol),0x20){
                mstore(add(ptr,0x20),0xc4609c1e)
                mstore(add(ptr,0x40),0x20)
                mstore(add(ptr,0x60),mload(symbol))
                revert(add(add(ptr,0x20),0x1c),0x44)
            }
            sstore(0x00,caller())
            sstore(0x03,initalSupply)
            sstore(0x04,mload(add(name,0x20)))
            sstore(0x05,mload(add(ptr,0x20)))
            mstore(ptr,caller())
            mstore(add(ptr,0x20),1)
            sstore(keccak256(ptr,0x40),initalSupply)
            
        }
    }
    

    function totalSupply()public view returns (uint256){
        assembly{
            let ptr:=mload(0x40)
            mstore(ptr,sload(3))
            return(ptr,0x20)
        }
    }

    function balanceOf(address _account)public view returns (uint256 _balance){
        assembly{
            let ptr:=mload(0x40)
            mstore(ptr,_account)
            mstore(add(ptr,0x20),1)
            let slot:=keccak256(ptr,0x40)
            _balance:=sload(slot)
        }
    }

    function transfer(address _to, uint256 _value)public returns (bool){
        assembly{
            let ptr:=mload(0x40)
            mstore(ptr,caller())
            mstore(add(ptr,0x20),1)
            let slot_from:=keccak256(ptr,0x40)
            
            let from_Balance:=sload(slot_from)
            
            if lt(from_Balance,_value){
                mstore(ptr,0xcf479181)
                mstore(add(ptr,0x20),from_Balance)
                mstore(add(ptr,0x40),_value)
                revert(add(ptr,0x1c),0x44)
            }
            ptr:=add(ptr,0x40)
            mstore(ptr,_to)
            mstore(add(ptr,0x20),1)
            let slot_to:=keccak256(ptr,0x40)
            let to_Balance:=sload(slot_to)
            sstore(slot_from,sub(from_Balance,_value))
            sstore(slot_to,add(to_Balance,_value))
            mstore(ptr,0x01)
            return(ptr,0x20)
        }

    }

    function allowance(address owner,address spender)public view returns (uint256){
        assembly{
            let ptr:=mload(0x40)
            mstore(ptr,owner)
            mstore(add(ptr,0x20),2)
            mstore(add(ptr,0x40),spender)
            mstore(add(ptr,0x60),keccak256(ptr,0x40))
            mstore(ptr,sload(keccak256(add(ptr,0x40),0x40)))
            return(ptr,0x20)
        }
    }

    function approve(address spender,uint256 amount)public returns (bool){
        assembly{
            let ptr:=mload(0x40)
            mstore(ptr,caller())
            mstore(add(ptr,0x20),2)
            mstore(add(ptr,0x40),spender)
            mstore(add(ptr,0x60),keccak256(ptr,0x40))
            sstore(keccak256(add(ptr,0x40),0x40),amount)
            mstore(ptr,0x01)
            return(ptr,0x20)
        }
    }

    function transferFrom(address from,address to,uint256 amount)public returns (bool){
        uint256 fromBalance;
        assembly{
            let ptr:=mload(0x40)
            mstore(ptr,from)
            mstore(add(ptr,0x20),2)
            mstore(add(ptr,0x40),caller())
            mstore(add(ptr,0x60),keccak256(ptr,0x40))
            mstore(ptr,keccak256(add(ptr,0x40),0x40))
            let _allowance:=sload(mload(ptr))
            if lt(_allowance,amount){
                mstore(ptr,0x2a1b2dd8)
                mstore(add(ptr,0x20),_allowance)
                mstore(add(ptr,0x40),amount)
                revert(add(ptr,0x1c),0x44)
            }
            sstore(mload(ptr),sub(_allowance,amount))
            
            mstore(ptr,from)
            mstore(add(ptr,0x20),1)
            let slot_from:=keccak256(ptr,0x40)
            let from_Balance:=sload(slot_from)
            fromBalance:=from_Balance
            
            if lt(from_Balance,amount){
                mstore(ptr,0xcf479181)
                mstore(add(ptr,0x20),from_Balance)
                mstore(add(ptr,0x40),amount)
                revert(add(ptr,0x1c),0x44)
            }
            mstore(ptr,to)
            mstore(add(ptr,0x20),0x01)
            let slot_to:=keccak256(ptr,0x40)
            sstore(slot_from,sub(from_Balance,amount))
            sstore(slot_to,add(sload(slot_to),amount))
            mstore(ptr,0x01)
            return(ptr,0x20)
            
        }
        
        
    }


    function batchTransfer(address[] memory receivers,uint256 amount)public returns (bool){
        assembly{
            let ptr:= mload(0x40)
            mstore(ptr,caller())
            mstore(add(ptr,0x20),1)
            mstore(ptr,sload(keccak256(ptr,0x40)))
            if eq(mload(ptr),0x00){
                mstore(ptr,0xf8118546)
                revert(add(ptr,0x1c),0x04)
            }
            if lt(mload(ptr),mul(mload(receivers),amount)){
                mstore(add(ptr,0x20),0xcf479181)
                mstore(add(ptr,0x40),mload(ptr))
                mstore(add(ptr,0x60),mul(mload(receivers),amount))
                revert(add(add(ptr,0x20),0x1c),0x44)
            }
            
            for {let i:=0x00} lt(i,mload(receivers)) {i:=add(i,0x01)}{
                mstore(ptr,mload(add(receivers,mul(add(i,0x01),0x20))))
                mstore(add(ptr,0x20),1)
                sstore(keccak256(ptr,0x40),add(sload(keccak256(ptr,0x40)),amount))
            }
            mstore(ptr,caller())
            mstore(add(ptr,0x20),1)
            sstore(keccak256(ptr,0x40),sub(sload(keccak256(ptr,0x40)), mul(amount,mload(receivers))))
            mstore(ptr,0x01)
            return(ptr,0x20)
        }        
    }
    


    function mint(address to,uint256 amount)public {
        assembly{
            let ptr:=mload(0x40)
            if iszero(eq(caller(),sload(0x00))){
                mstore(ptr,0x118cdaa7)
                mstore(add(ptr,0x20),caller())
                revert(add(ptr,0x1c),0x24)

            }
            mstore(ptr,to)
            mstore(add(ptr,0x20),1)
            mstore(ptr,keccak256(ptr,0x40))
            sstore(mload(ptr),add(sload(mload(ptr)),amount))
            sstore(3,add(sload(3),amount))
        }
    }

    function burn(address from,uint256 amount)public {
        assembly{
            let ptr:=mload(0x40)
            if iszero(eq(caller(),sload(0x00))){
                mstore(ptr,0x118cdaa7)
                mstore(add(ptr,0x20),caller())
                revert(add(ptr,0x1c),0x24)
            }
            mstore(ptr,from)
            mstore(add(ptr,0x20),1)
            mstore(ptr,keccak256(ptr,0x40))
            mstore(add(ptr,0x20),sload(mload(ptr)))
            if lt(mload(add(ptr,0x20)),amount){
                mstore(ptr,0xcf479181)
                mstore(add(ptr,0x20),mload(add(ptr,0x20)))
                mstore(add(ptr,0x40),amount)
                revert(add(ptr,0x1c),0x44)
            }
            sstore(mload(ptr),sub(mload(add(ptr,0x20)),amount))
            sstore(3,sub(sload(3),amount))
        }
    }

}
