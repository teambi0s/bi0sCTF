pragma solidity ^0.8.20;

import {LamboToken} from "./LamboToken.sol";
import {IUniswapV2Factory} from "../uniswap-v2/interfaces/IUniswapV2Factory.sol";
import {IUniswapV2Pair} from "../uniswap-v2/interfaces/IUniswapV2Pair.sol";
import {VasthavikamainaToken} from "./VasthavikamainaToken.sol";
import {Factory} from "./Factory.sol";
contract WhiteListed{

    error WhiteListed__Incorrect__ETH__Sent(uint256 _expectedAmount,uint256 _actualAmountReceived);
    error WhiteListed__InsufficientOutputAmount(uint256 _expectedAmount,uint256 _actualAmount);
    error WhiteListed__Call__Failed();
    error WhiteListed__Invalid__Factory(address _invalidFactory);
    bytes32 UNISWAP_PAIR_INIT_HASH;

    IUniswapV2Factory uniswapFactory;
    VasthavikamainaToken immutable vasthavikamainaToken;

    constructor(address _uniswapFactory,address _vasthavikamainaToken){
        uniswapFactory=IUniswapV2Factory(_uniswapFactory);
        vasthavikamainaToken=VasthavikamainaToken(_vasthavikamainaToken);
    }

    function setInitHash(bytes32 _initHash)public{
        UNISWAP_PAIR_INIT_HASH=_initHash;
    }

    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
        require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
        require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
        uint amountInWithFee = amountIn*(997);
        uint numerator = amountInWithFee*(reserveOut);
        uint denominator = reserveIn*(1000)+(amountInWithFee);
        amountOut = numerator / denominator;
    }

    function __getToken0andToken1(address _token0,address _token1)internal pure returns(address,address){
        if(uint160(_token0)<uint160(_token1)){
            return (_token0,_token1);
        }else{
            return(_token1,_token0);
        }
    }

    function __calculatePoolAddress(address _uniswapFactory,address _token0,address _token1)internal view returns (address){
        (_token0,_token1)=__getToken0andToken1(_token0,_token1);
        bytes32 _salt=keccak256(abi.encodePacked(_token0,_token1));
        address _poolAddress=address(uint160(uint256(keccak256(abi.encodePacked(bytes1(0xff),_uniswapFactory,_salt,UNISWAP_PAIR_INIT_HASH)))));
        return _poolAddress;
    }

    
    function buyQuote(address _lamboToken,uint256 _amountIn,uint256 _minOut)public payable returns (uint256){
        if(msg.value<_amountIn){
            revert WhiteListed__Incorrect__ETH__Sent(_amountIn,msg.value);
        }
        address _uniPair=__calculatePoolAddress(address(uniswapFactory),address(vasthavikamainaToken),_lamboToken);
        (uint112 _reserve0,uint112 _reserve1,)=IUniswapV2Pair(_uniPair).getReserves();
        (address _token0,)=__getToken0andToken1(_lamboToken,address(vasthavikamainaToken));
        uint256 _amountOut;
        uint256 _amount0Out;
        uint256 _amount1Out;
        if(_token0==address(vasthavikamainaToken)){
            _amountOut=getAmountOut(_amountIn,uint256(_reserve0),uint256(_reserve1));
            _amount1Out=_amountOut;
        }else{
            _amountOut=getAmountOut(_amountIn,uint256(_reserve1),uint256(_reserve0));
            _amount0Out=_amountOut;
        }
        if(_amountOut<_minOut){
            revert WhiteListed__InsufficientOutputAmount(_minOut,_amountOut);
        }
        vasthavikamainaToken.cashIn{value:_amountIn}();
        vasthavikamainaToken.transfer(_uniPair, _amountIn);
        IUniswapV2Pair(_uniPair).swap(_amount0Out, _amount1Out, msg.sender, "");
        if(msg.value>_amountIn){
            uint256 _balanceLeft=msg.value-_amountIn;
            (bool success,)=payable(msg.sender).call{value: _balanceLeft }("");
            if(!success){
                revert WhiteListed__Call__Failed();
            }
        }
        return _amountOut;
    }

    function sellQuote(address _lamboToken,uint256 _amountIn,uint256 _minOut)public returns (uint256){
        LamboToken(_lamboToken).transferFrom(msg.sender, address(this), _amountIn);
        address _uniPair=__calculatePoolAddress(address(uniswapFactory),address(vasthavikamainaToken),_lamboToken);
        (uint112 _reserve0,uint112 _reserve1,)=IUniswapV2Pair(_uniPair).getReserves();
        (address _token0,)=__getToken0andToken1(_lamboToken,address(vasthavikamainaToken));
        uint256 _amountOut;
        uint256 _amount0Out;
        uint256 _amount1Out;
        if(_token0==address(vasthavikamainaToken)){
            _amountOut=getAmountOut(_amountIn,uint256(_reserve1),uint256(_reserve0));
            _amount0Out=_amountOut;
        }else{
            _amountOut=getAmountOut(_amountIn,uint256(_reserve0),uint256(_reserve1));
            _amount1Out=_amountOut;
        }
        if(_amountOut<_minOut){
            revert WhiteListed__InsufficientOutputAmount(_minOut,_amountOut);
        }
        LamboToken(_lamboToken).transfer(_uniPair, _amountIn);
        IUniswapV2Pair(_uniPair).swap(_amount0Out, _amount1Out,address(this), "");
        vasthavikamainaToken.cashOut(_amountOut);
        payable(msg.sender).call{value:_amountOut }("");
        return _amountOut;
    }

    function createPair_And_buyQuote(Factory _factory,string memory _name,string memory _symbol, uint256 _loanAmount,uint256 _amountIn,uint256 _minOut)public payable returns (address,LamboToken,uint256){ 
        if(!vasthavikamainaToken.isValidFactory(address(_factory))){
            revert WhiteListed__Invalid__Factory(address(_factory));
        }
        if(msg.value<_amountIn){
            revert WhiteListed__Incorrect__ETH__Sent(_amountIn,msg.value);
        }
        (address _uniPair,LamboToken _lamboToken)=_factory.createPair(_name, _symbol, _loanAmount, address(vasthavikamainaToken));
        (uint112 _reserve0,uint112 _reserve1,)=IUniswapV2Pair(_uniPair).getReserves();
        (address _token0,)=__getToken0andToken1(address(_lamboToken),address(vasthavikamainaToken));
        uint256 _amountOut;
        uint256 _amount0Out;
        uint256 _amount1Out;
        if(_token0==address(vasthavikamainaToken)){
            _amountOut=getAmountOut(_amountIn,uint256(_reserve0),uint256(_reserve1));
            _amount1Out=_amountOut;
        }else{
            _amountOut=getAmountOut(_amountIn,uint256(_reserve1),uint256(_reserve0));
            _amount0Out=_amountOut;
        }
        if(_amountOut<_minOut){
            revert WhiteListed__InsufficientOutputAmount(_minOut,_amountOut);
        }
        vasthavikamainaToken.cashIn{value:_amountIn}();
        vasthavikamainaToken.transfer(_uniPair, _amountIn);
        IUniswapV2Pair(_uniPair).swap(_amount0Out, _amount1Out, msg.sender, "");
        if(msg.value>_amountIn){
            uint256 _balanceLeft=msg.value-_amountIn;
            (bool success,)=payable(msg.sender).call{value: _balanceLeft }("");
            if(!success){
                revert WhiteListed__Call__Failed();
            }
        }
        return (_uniPair,_lamboToken,_amountOut);
    }

    receive()external payable{

    }
}