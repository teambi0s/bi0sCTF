//SPDX-Identifier-License: BUSL-1.1
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {LamboToken} from "./LamboToken.sol";
import {IUniswapV2Factory} from "../uniswap-v2/interfaces/IUniswapV2Factory.sol";
import {IUniswapV2Pair} from "../uniswap-v2/interfaces/IUniswapV2Pair.sol";
import {VasthavikamainaToken} from "./VasthavikamainaToken.sol";

contract Factory is Ownable{

    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/
    event Factory__Account__WhiteListed(address indexed _whiteListedAddress);
    event Factory__Account__UnWhiteListed(address indexed _unWhiteListedAddress);
    event Factory__PairCreated(address _vasthavikamainaToken,address _lamboToken,address _uniswapPair,uint256 _vasthavikamainaTokenLoanAmount);
    event Factory__LiquidityAdded(address _vasthavikamainaToken,address _lamboToken,uint256 _vasthavikamainaTokenAmount,uint256 _lamboTokenAmount);
    error Factory__VasthavikamainaToken__Not_WhiteListed(address _unWhiteListedToken);
    error Factory__Zero__Address();
    uint256 _poolsCount;
    address public whiteListContract;
    mapping(address=>bool) _whiteList; 
    IUniswapV2Factory uniswapFactory;

    bytes32 UNISWAP_PAIR_INIT_HASH;

    constructor(address _uniswapFactory)Ownable(msg.sender){
        if(_uniswapFactory==address(0)){
            revert Factory__Zero__Address();
        }
        uniswapFactory=IUniswapV2Factory(_uniswapFactory);
    }

    function setInitHash(bytes32 _initHash)public{
        UNISWAP_PAIR_INIT_HASH=_initHash;
    }

    function setWhiteList(address _accountTo_WhiteList)external onlyOwner{
        if(_accountTo_WhiteList==address(0)){
            revert Factory__Zero__Address();
        }
        _whiteList[_accountTo_WhiteList]=true;
        emit Factory__Account__WhiteListed(_accountTo_WhiteList);
    }

    function unSetWhiteList(address _accountTo_UnWhiteList)external onlyOwner{
        if(_accountTo_UnWhiteList==address(0)){
            revert Factory__Zero__Address();
        }
        _whiteList[_accountTo_UnWhiteList]=false;
        emit Factory__Account__UnWhiteListed( _accountTo_UnWhiteList);
    }


    function setWhiteListContract(address _whiteListContract)external onlyOwner{
        if(_whiteListContract==address(0)){
            revert Factory__Zero__Address();
        }
        whiteListContract=_whiteListContract;
    }

    function getWhiteListContractAddress()external view returns(address){
        return whiteListContract;
    }

    function getpoolCount()external view returns(uint256){
        return _poolsCount;
    }

    function getWhiteList(address _addressToBeChecked)external view returns(bool){
        return _whiteList[_addressToBeChecked];
    }

    function __getToken0andToken1(address _token0,address _token1)internal pure returns(address,address){
        if(uint160(_token0)<uint160(_token1)){
            return (_token0,_token1);
        }else{
            return(_token1,_token0);
        }
    }

    function __calculatePoolAddress(address _token0,address _token1)internal view returns (address){
        (_token0,_token1)=__getToken0andToken1(_token0,_token1);
        bytes32 _salt=keccak256(abi.encodePacked(_token0,_token1));
        address _poolAddress=address(uint160(uint256(keccak256(abi.encodePacked(bytes1(0xff),address(uniswapFactory),_salt,UNISWAP_PAIR_INIT_HASH)))));
        return _poolAddress;
    }


    function createPair(string memory _name,string memory _symbol,uint256 _loanAmount,address _vasthavikamainaToken)external returns (address,LamboToken){
        if(!_whiteList[_vasthavikamainaToken]){
            revert Factory__VasthavikamainaToken__Not_WhiteListed(_vasthavikamainaToken);
        }
        _poolsCount+=1;
        bytes memory _byteCode=abi.encodePacked(type(LamboToken).creationCode,abi.encode(_name,_symbol));
        bytes32 salt = keccak256(abi.encodePacked(_name, _symbol));
        LamboToken _lamboToken;
        assembly{
            let bytecode_ptr := add(_byteCode, 0x20)
            let bytcode_size := mload(_byteCode)
            let result := create2(0, bytecode_ptr, bytcode_size, salt)
            if iszero(result){
                revert(0,0)
            }
            _lamboToken:=result
        }
        _lamboToken.initialize();
        address _uniPair=uniswapFactory.createPair(address(_lamboToken), _vasthavikamainaToken);
        VasthavikamainaToken(_vasthavikamainaToken).takeLoan(_uniPair, _loanAmount);
        _lamboToken.transfer(_uniPair, 1e26);
        IUniswapV2Pair(_uniPair).mint(address(0));
        emit Factory__PairCreated(_vasthavikamainaToken,address(_lamboToken),_uniPair,_loanAmount);
        return (_uniPair,_lamboToken);
    }

    function addVasthavikamainaLiquidity(address _vasthavikamainaToken,address _lamboToken,uint256 _loanAmount,uint256 _quoteAmount)external returns(uint256){
        if(!_whiteList[_vasthavikamainaToken]){
            revert Factory__VasthavikamainaToken__Not_WhiteListed(_vasthavikamainaToken);
        }
        address _uniPair=__calculatePoolAddress(_vasthavikamainaToken,_lamboToken);
        (address _token0,)=__getToken0andToken1(_vasthavikamainaToken,_lamboToken);
        (uint112 _reserve0,uint112 _reserve1,)=IUniswapV2Pair(_uniPair).getReserves();
        uint256 _lamboTokens_To_Transfer;
        if(_token0==_vasthavikamainaToken){
            _lamboTokens_To_Transfer= (_loanAmount*_reserve1)/_reserve0;
        }else{
            _lamboTokens_To_Transfer= (_loanAmount*_reserve0)/_reserve1;
        }
        VasthavikamainaToken(_vasthavikamainaToken).takeLoan(_uniPair, _loanAmount);
        LamboToken(_lamboToken).transferFrom(msg.sender, _uniPair, _lamboTokens_To_Transfer);
        IUniswapV2Pair(_uniPair).mint(address(0));

        emit Factory__LiquidityAdded(_vasthavikamainaToken,_lamboToken,_loanAmount,_lamboTokens_To_Transfer);
        return _lamboTokens_To_Transfer;
    }
}