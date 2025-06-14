//SPDX-license-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Test,console} from "forge-std/Test.sol";
import {WETH9} from "./WETH.sol";
interface IFlashLoanRecipient{
    function receiveFlashLoan(IERC20[] memory _tokens,uint256[] memory _amounts,uint256[] memory _feeAmounts,bytes memory _data)external virtual;
}

contract Balancer is Ownable{

    error Balancer__Incorrect__Length(uint8 _left,uint8 _right);
    error Balancer__Flash__Fee__Limit__Exceeded();
    error Balancer__Flash__Loan__Unpaid();
    error Balancer__Flash__Loan__Fee__Unpaid();
    error Balancer__Unapproved__Token(address _token);
    error Balancer__Insufficient__User__Balance(uint256 _expectedAmount,uint256 _actualAmount);
    error Balancer__ReEntrancy__prohibited();
    
    event TokenAprooved(address indexed _token);
    event TokenRevoked(address indexed _token);
    event TokensAproovedInBatch(address[] indexed _tokens);
    event TokensRevokedInBatch(address[] indexed _tokens);
    event TokensStatusChanged(address[] indexed _tokens,bool[] indexed _status);
    event FlashLoan(IFlashLoanRecipient _recipient,IERC20 _token,uint256 _amount,uint256 _feeAmount);
    event Liquidity__Added(address _liquidityProvider,address _token,uint256 _amount);

    mapping(address => bool) public approvedTokens;
    mapping(address token =>mapping(address user=>uint256 amount)) tokenBalances;
    uint256 public flashFee;
    uint24 public max_flashFee=2_000;
    uint24 public max_BIPS=100_000;
    bool public entered;
    bool public flashLoanTaken;
    constructor()Ownable(msg.sender){

    }

    modifier nonReentrant(){
        if(entered){
            revert Balancer__ReEntrancy__prohibited();
        }
        entered=true;
        _;
        entered=false;
    }

    function setflashFee(uint24 _fee)external{
        if(_fee>max_flashFee){
            revert Balancer__Flash__Fee__Limit__Exceeded();
        }
        flashFee=_fee;
    }

    function approveToken(address _token)external onlyOwner{
        approvedTokens[_token]=true;
        emit TokenAprooved(_token);
    }

    function revokeToken(address _token) external onlyOwner {
        approvedTokens[_token] = false;
        emit TokenRevoked(_token);
    }

    function approveTokenInBatch(address[] memory _tokens)external onlyOwner{
        for(uint8 i=0;i<_tokens.length;i++){
            approvedTokens[_tokens[i]]=true;
        }
        emit TokensAproovedInBatch(_tokens);
    }

    function revokeTokenInBatch(address[] memory _tokens)external onlyOwner{
        for(uint8 i=0;i<_tokens.length;i++){
            approvedTokens[_tokens[i]]=false;
        }
        emit TokensRevokedInBatch(_tokens);
    }

    function changeTokensStatus(address[] memory _tokens,bool[] memory _status)external onlyOwner{
        if(_tokens.length!=_status.length){
            revert Balancer__Incorrect__Length(uint8(_tokens.length),uint8(_status.length));
        }
        for(uint8 i=0;i<_tokens.length;i++){
            approvedTokens[_tokens[i]]=_status[i];
        }
        emit TokensStatusChanged(_tokens,_status);
    }

    function flashloan(IFlashLoanRecipient recipient,IERC20[] memory _tokens,uint256[] memory _amounts,bytes memory _data)external nonReentrant{
        flashLoanTaken=true;
        if(_tokens.length!=_amounts.length){
            revert Balancer__Incorrect__Length(uint8(_tokens.length),uint8(_amounts.length));
        }
        uint256[] memory _feeAmounts=new uint256[](_tokens.length);
        uint256[] memory _preLoanBalances = new uint256[](_tokens.length);
        for(uint8 i=0;i<_tokens.length;i++){
            
            IERC20 _token=_tokens[i];
            if(!approvedTokens[address(_token)]){
                revert Balancer__Unapproved__Token(address(_token));
            }
            uint256 _amount=_amounts[i];
            _feeAmounts[i]=_calculateFlashFee(_amount);
            _preLoanBalances[i]=_token.balanceOf(address(this));
            _token.transfer(address(recipient), _amount);
        }
        recipient.receiveFlashLoan(_tokens, _amounts, _feeAmounts, _data);

        for(uint8 i=0;i<_tokens.length;i++){
            IERC20 _token=_tokens[i];
            uint256 _preloanBalance=_preLoanBalances[i];
            uint256 _feeAmount=_feeAmounts[i];
            uint256 _postloanBalance=_token.balanceOf(address(this));

            if(_postloanBalance<_preloanBalance){
                revert Balancer__Flash__Loan__Unpaid();
            }

            uint256 _receivedFeeAmount=_postloanBalance-_preloanBalance;

            if(_receivedFeeAmount<_feeAmount){
                revert Balancer__Flash__Loan__Fee__Unpaid();
            }

            emit FlashLoan(recipient,_token,_amounts[i],_receivedFeeAmount);
        }
        flashLoanTaken=false;
        
    }

    function provideLiquidity(address _token,uint256 _amount)external nonReentrant{
        if(!approvedTokens[address(_token)]){
            revert Balancer__Unapproved__Token(address(_token));
        }
        IERC20(_token).transferFrom(msg.sender, address(this), _amount);
        tokenBalances[_token][msg.sender]+=_amount;
        emit Liquidity__Added(msg.sender,_token,_amount);
    }

    function takeOffLiquidity(address _token,uint256 _amount)external nonReentrant{
        uint256 user_balance=tokenBalances[_token][msg.sender];
        if(_amount>user_balance){
            revert Balancer__Insufficient__User__Balance(_amount,user_balance);
        }
        IERC20(_token).transfer(msg.sender, _amount);
    }

    function _calculateFlashFee(uint256 _amount)internal view returns (uint256 _fee){
        _fee=(_amount*flashFee)/max_BIPS;
    }
}