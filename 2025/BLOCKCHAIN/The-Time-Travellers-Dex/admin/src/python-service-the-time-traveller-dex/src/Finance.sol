//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Ownable} from "@openzeppelin-contracts/access/Ownable.sol";
import {IDEX} from "./interfaces/IDEX.sol";
import {ERC20} from "@openzeppelin-contracts/token/ERC20/ERC20.sol";
import {IERC3156FlashLender} from "./interfaces/IERC3156FlashLender.sol";
import "./interfaces/IERC3156FlashBorrower.sol";
import {Currency} from "./Currency.sol";
import {DEX} from "./DEX.sol";
import {console} from "forge-std/Test.sol";

contract Finance is IERC3156FlashLender ,Ownable {

    /*//////////////////////////////////////////////////////////////
                                 ERRORS
    //////////////////////////////////////////////////////////////*/

    error FINANCE_Invalid_Token(address _error_token);
    error FINANCE_Expected_Amount_Not_Transferred(uint256 _amount,uint256 _actualTransferredAmount);
    error FINANCE_Withdraw_Failed();
    error FINANCE_Loan_Amount_Exceeded_Max_Loan_Amount(uint256 _loan_amount,uint256 _max_loan_amount);
    error FINANCE_Re_Entrancy_Prohibited();
    error FINANCE_Invalid_Stake_Amount(uint256 _sentAmount,uint256 _minEther);
    error FINANCE_Price_Is_Not_Yet_Expired();
    error FINANCE_Price_Is_Expired();
    error FINANCE_Prices_Not_Update_Since_Last_SnapShot();
    error FINANCE_SnapShot_Not_Yet_Taken();
    error FINANCE_FLASHLOAN_LIMIT_PER_DAY_REACHED();
    /*//////////////////////////////////////////////////////////////
                               CONSTANTS
    //////////////////////////////////////////////////////////////*/

    uint16 constant MAX_PERCENT=10000; //100%

    /*//////////////////////////////////////////////////////////////
                            STATE VARIABLES
    //////////////////////////////////////////////////////////////*/

    
    mapping(address token=>uint256 feeCollected) feesCollected;
    Currency public WETH;
    Currency public INR;
    DEX public dex;
    mapping(address _tokenAddress => bool _Allowed) public approvedTokens;
    mapping(address=>uint256) public maxFlashLoan;
    uint16 flashloanfee;
    uint64 constant MIN_STAKE=0.5 ether;
    bool public entered;
    mapping(address token=> uint256 LatestBalance) LatestBalances;

    uint256 public lastSnapshotTime;
    uint256 public wethPriceCumulative;
    uint256 public inrPriceCumulative;
    uint256 WETH_AMOUNT=50_000 * 10 ether;
    uint256 INR_AMOUNT= 2_30_000 * 50_000 * 10 ether;
    uint8 MAX_FLASH_LOAN_PER_DAY=1;
    uint8 FLASH_LOANS_UTILIZED;
    uint256 FLASH_LOAN_START_TIME_STAMP=block.timestamp;

    modifier nonReentrant(){
        if(entered==true){
            revert FINANCE_Re_Entrancy_Prohibited();
        }
        entered=true;
        _;
        entered=false;
    }

    modifier approvedChecker(address _token){
        if(!approvedTokens[_token]){
            revert FINANCE_Invalid_Token(_token);
        }
        _;
    }

    constructor(
        uint16 _flashloanfee,
        uint256 _wethMaxFlashloan,
        uint256 _inrMaxFlashloan,
        address _dex
        )Ownable(msg.sender) payable{
        flashloanfee=_flashloanfee;
        WETH=new Currency("WRAPPED ETHER","WETH");
        INR=new Currency("INDIAN RUPEE","INR");
        maxFlashLoan[address(WETH)]=_wethMaxFlashloan;
        maxFlashLoan[address(INR)]=_inrMaxFlashloan;
        approvedTokens[address(WETH)]=true;
        approvedTokens[address(INR)]=true;
        dex=DEX(_dex);
        WETH.mint(address(this), WETH_AMOUNT);
        INR.mint(address(this), INR_AMOUNT);
        LatestBalances[address(WETH)]+=WETH_AMOUNT;
        LatestBalances[address(INR)]+=INR_AMOUNT;
    }

    function stake(address _tokenOut)external payable  approvedChecker(_tokenOut)returns (uint256){
        if(msg.value<MIN_STAKE){
            revert FINANCE_Invalid_Stake_Amount(msg.value,MIN_STAKE);
        }
        if(_tokenOut==address(WETH)){
            Currency(_tokenOut).transfer(msg.sender,msg.value);
            LatestBalances[address(WETH)]-=msg.value;
            return msg.value;
        }else{
            (uint256 _wethPriceInInr,)=this.getPrice();
            uint256 _tokensToMinted= (msg.value*_wethPriceInInr)/( 2**112);
            Currency(_tokenOut).transfer(msg.sender,_tokensToMinted);
            LatestBalances[address(INR)]-=_tokensToMinted;
            return _tokensToMinted;
        }
    }

    function withdraw(address _token,uint256 _amount)external nonReentrant approvedChecker(_token){
        uint256 _tokensReceived=Currency(_token).balanceOf(address(this))-feesCollected[_token]-LatestBalances[_token];
        
        if(_tokensReceived<_amount){
            revert FINANCE_Expected_Amount_Not_Transferred(_amount,_tokensReceived);
        }
        LatestBalances[_token]+=_tokensReceived;
        if(_token==address(WETH)){
            (bool success,)=payable(msg.sender).call{value: _tokensReceived}("");
            if(!success){
                revert FINANCE_Withdraw_Failed();
            }
        }else{
            (uint256 _WethPriceInInr,uint256 _InrPriceInWeth)=this.getPrice();
            uint256 _Eth_To_Transfer= ((_InrPriceInWeth* _tokensReceived )/(2**112))+1;//rounding up 
            (bool success,)=payable(msg.sender).call{value: _Eth_To_Transfer}(""); 
            if(!success){
                revert FINANCE_Withdraw_Failed();
            }
        }   
    }

    function flashFee(address token,uint256 amount) external view returns (uint256){
        if (!approvedTokens[token]){
            revert FINANCE_Invalid_Token(token);
        }

        return (flashloanfee*amount)/MAX_PERCENT;
    }


    function maxflashLoan(address token) external view returns (uint256){
        if (!approvedTokens[token]){
            revert FINANCE_Invalid_Token(token);
        }
        return maxFlashLoan[token];
    }

    function flashLoan(
        IERC3156FlashBorrower receiver,
        address token,
        uint256 amount,
        bytes calldata data
    ) external nonReentrant approvedChecker(token) returns (bool) {
        if(block.timestamp-FLASH_LOAN_START_TIME_STAMP<1 days){
            if(FLASH_LOANS_UTILIZED<MAX_FLASH_LOAN_PER_DAY){
                FLASH_LOANS_UTILIZED++;
            }else{
                revert FINANCE_FLASHLOAN_LIMIT_PER_DAY_REACHED();
            }
        }else{
            FLASH_LOAN_START_TIME_STAMP+=1 days;
            FLASH_LOANS_UTILIZED++;
        }
        if(amount > maxFlashLoan[token]){
            revert FINANCE_Loan_Amount_Exceeded_Max_Loan_Amount(amount,maxFlashLoan[token]);
        }
        Currency(token).transfer(address(receiver),amount);
        uint256 fee=(flashloanfee*amount)/MAX_PERCENT;
        receiver.onFlashLoan(msg.sender,token, amount, fee, data);
        uint256 _amount_with_fee=amount+fee;    

        Currency(token).transferFrom(address(receiver), address(this), _amount_with_fee);
        feesCollected[token]+=fee;
        return true;
    }   

    function mint(address _token,address _to,uint256 _value)public onlyOwner{
        if(_token==address(WETH)){
            WETH.mint(_to,_value);
        }else if (_token ==address(INR)){
            INR.mint(_to,_value);
        }
        else{
            revert FINANCE_Invalid_Token(_token);
        }
    }

    function burn(address _token,address _from,uint256 _amount)public onlyOwner{
        if(_token==address(WETH)){
            WETH.burn(_from,_amount);
        }else if (_token ==address(INR)){
            INR.burn(_from,_amount);
        }
        else{
            revert FINANCE_Invalid_Token(_token);
        }
    }

     

    /*//////////////////////////////////////////////////////////////
                             PRICE FETCHERS
    //////////////////////////////////////////////////////////////*/


    function timeElapsed() public view returns (uint256 _time) {
        _time=block.timestamp-lastSnapshotTime;
    }

    function snapshot()public{
        (uint256 _price0,uint256 _price1,uint256 _lastTimeStamp)=dex.get_Cumulative_Prices();
        uint256 time_Elapsed=timeElapsed();
        if(time_Elapsed< 1 minutes){
            revert FINANCE_Price_Is_Not_Yet_Expired();
        }
        wethPriceCumulative=_price0;
        inrPriceCumulative=_price1;
        lastSnapshotTime=_lastTimeStamp;
    }

    function getPrice() public view returns (uint256 _wethPrice,uint256 _inrPrice){
        uint256 time_Elapsed=timeElapsed();
        if(lastSnapshotTime==0){
            revert FINANCE_SnapShot_Not_Yet_Taken();
        }
        if(time_Elapsed>= 2 minutes){
            revert FINANCE_Price_Is_Expired();
        }
        
        (uint256 _price0,uint256 _price1,)=dex.get_Cumulative_Prices();
        
        uint256 _timeElapsed= dex.timeStampLast()-lastSnapshotTime;
        
        if(_timeElapsed==0){
            revert FINANCE_Prices_Not_Update_Since_Last_SnapShot();
        }
        _wethPrice= (_price0-wethPriceCumulative)/_timeElapsed;
        _inrPrice= (_price1-inrPriceCumulative)/_timeElapsed; 
    }
}