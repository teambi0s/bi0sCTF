//SPDX-license-Identifier: MIT
pragma solidity ^0.8.20;


contract WETH9{

    error WETH__Insufficient__Balance(uint256 _expectedBalance,uint256 _actualBalance);
    error WETH__Call__Failed();
    error InsufficientAllowance(uint256 _expectedAllowance,uint256 _actualAllowance);

    event Deposited(address _ethSender,address _wethReceiver,uint256 _amount);
    event Withdraw(address _wethHolder,address _ethReceiver,uint256 _amount);
    event Transfer(address _from,address _to,uint256 _amount);
    event Approved(address _from,address _to,uint256 _amount);
    mapping(address=>uint256) balances;
    mapping(address=>mapping(address=>uint256)) allowances;
    string public name="Wrapped Ether";
    string public symbol   = "WETH";
    uint8  public decimals = 18;

    function balanceOf(address _user)external view returns (uint256){
        return balances[_user];
    }

    function allowance(address _owner, address _spender)external view returns (uint256){
        return allowances[_owner][_spender];
    }

    function deposit(address _wethReceiver)external payable{
        uint256 _wethToTransfer=msg.value;
        _mint(_wethReceiver,_wethToTransfer);
        emit Deposited(msg.sender,_wethReceiver,_wethToTransfer);
    }

    function withdraw(address _ethReceiver,uint256 _wethAmountToWIthdraw)public{
        address _wethHolder=msg.sender;
        _burn(_wethHolder, _wethAmountToWIthdraw);
        (bool success,)=payable(_ethReceiver).call{value:_wethAmountToWIthdraw}("");
        if(!success){
            revert WETH__Call__Failed();
        }
        emit Withdraw(_wethHolder, _ethReceiver, _wethAmountToWIthdraw);
    }

    function transfer(address _to,uint256 _amount)external returns(bool){
        _update(msg.sender,_to,_amount);
        return true;
    }

    function transferFrom(address _from,address _receiver,uint256 _amount)external returns(bool){
        uint256 _allowance=allowances[_from][msg.sender];
        if(_allowance<_amount){
            revert InsufficientAllowance(_amount,_allowance);
        }
        allowances[_from][msg.sender]-=_amount;
        _update(_from,_receiver,_amount);
        return true;
    }

    function approve(address _to,uint256 _amount)external returns(bool){
        allowances[msg.sender][_to]+=_amount;
        emit Approved(msg.sender,_to,_amount);
        return true;
    }

    function _mint(address _user,uint256 _amount)internal{
        balances[_user]+=_amount;
    }

    function _burn(address _user,uint256 _amount)internal{
        uint256 _userBalance=balances[_user];
        if(_userBalance<_amount){
            revert WETH__Insufficient__Balance(_amount,_userBalance);
        }
        balances[_user]-=_amount;
    }

    function _update(address _from,address _to,uint256 _amount)internal{
        uint256 _holderBalance=balances[_from];
        if(_holderBalance<_amount){
            revert WETH__Insufficient__Balance(_amount,_holderBalance);
        }
        balances[_from]-=_amount;
        balances[_to]+=_amount;
        emit Transfer(_from,_to,_amount);
    }


}