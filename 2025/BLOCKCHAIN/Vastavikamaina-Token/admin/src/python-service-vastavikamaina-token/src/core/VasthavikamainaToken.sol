//SPDX-Identifier-License: BUSL-1.1
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract VasthavikamainaToken is ERC20,Ownable{

    constructor()ERC20("Vasthavikamaina ETH","VSTETH") Ownable(msg.sender){

    }
    uint256 public cashOutFee;
    uint256 public lastLoanBlock;
    uint256 public loanedAmountThisBlock;
    uint256 public totalCashOutFeesCollected;
    uint256 public MAX_LOAN_PER_BLOCK = 300 ether;

    mapping(address => uint256) public _debt;
    mapping(address => bool) public whiteList;
    mapping(address => bool) public validFactories;

    event LoanTaken(address user, uint256 amount);
    event LoanRepaid(address user, uint256 amount);
    event Wrap(address user, uint256 amount);
    event Unwrap(address user, uint256 amount);
    event Withdraw(address owner, uint256 amount);

    error VasthavikamainaToken__Call__Failed();
    error VasthavikamainaToken__Not__WhiteListed(address _unWhiteListedAddress);
    error VasthavikamainaToken__Not__A__Valid__Factory(address _inValidFactory);
    error VasthavikamainaToken__Loan__Limit__Per__Block__Exceeded(uint256 _Loan_In_this_Block,uint256 _MAX_LOAN_PER_BLOCK);
    error VasthavikamainaToken__DebtOverflow(address user, uint256 debt, uint256 value);
    error VasthavikamainaToken__WithDraw__Amount__Exceeds__Fee__Collected(uint256 _amount_To_Be_Withdrawn,uint256 _feesCOllected);
    error VasthavikamainaToken__Insufficient__Funds(uint256 _amount_To_Be_Withdrawn,uint256 _actualBalance);

    modifier nonReentrant(){
        _;
    }

    modifier onlyWhiteListed() {
        if(!whiteList[msg.sender]){
            revert VasthavikamainaToken__Not__WhiteListed(msg.sender);
        }
        _;
    }

    modifier onlyValidFactory() {
        if(!validFactories[msg.sender]){
            revert VasthavikamainaToken__Not__A__Valid__Factory(msg.sender);
        }
        _;
    }


    function isValidFactory(address _factory) external view returns (bool) {
        return validFactories[_factory];
    }

    function updateFactory(address _factory, bool isValid) external onlyOwner {
        validFactories[_factory] = isValid;
    }

    function updateCashOutFee(uint256 _cashOutFee) external onlyOwner {
        cashOutFee = _cashOutFee;
    }

    function addToWhiteList(address user) external onlyOwner {
        whiteList[user] = true;
    }

    function removeFromWhiteList(address user) external onlyOwner {
        whiteList[user] = false;
    }

    function getCashOutQuote(uint256 amount) public view returns (uint256 amountAfterFee) {
        uint256 fee = (amount * cashOutFee) / 10000;
        amountAfterFee = amount - fee;
    }

    function cashIn() external payable onlyWhiteListed {
        _mint(msg.sender, msg.value);
        emit Wrap(msg.sender, msg.value);
    }

    function cashOut(uint256 amount) external onlyWhiteListed returns (uint256 amountAfterFee) {
        uint256 fee = (amount * cashOutFee) / 10000;
        totalCashOutFeesCollected += fee;
        amountAfterFee = amount - fee;

        _burn(msg.sender, amount);
        (bool success, ) =msg.sender.call{value:amountAfterFee }("");
        if(!success){
            revert VasthavikamainaToken__Call__Failed();
        }
        emit Unwrap(msg.sender, amountAfterFee);
    }

    function takeLoan(address to, uint256 amount) external payable nonReentrant onlyValidFactory {
        if (block.number > lastLoanBlock) {
            lastLoanBlock = block.number;
            loanedAmountThisBlock = 0;
        }
        uint256 _LoanAmountInThisBlockWIthCurrentLoan=loanedAmountThisBlock + amount;
        if(_LoanAmountInThisBlockWIthCurrentLoan > MAX_LOAN_PER_BLOCK){
            revert VasthavikamainaToken__Loan__Limit__Per__Block__Exceeded(_LoanAmountInThisBlockWIthCurrentLoan,MAX_LOAN_PER_BLOCK);
        }
        
        loanedAmountThisBlock += amount;
        _mint(to, amount);
        _increaseDebt(to, amount);

        emit LoanTaken(to, amount);
    }

    function repayLoan(address to, uint256 amount) external nonReentrant onlyValidFactory {
        _burn(to, amount);
        _decreaseDebt(to, amount);

        emit LoanRepaid(to, amount);
    }

    function getLoanDebt(address user) external view returns (uint256) {
        return _debt[user];
    }

    function _increaseDebt(address user, uint256 amount) internal {
        _debt[user] += amount;
    }

    function _decreaseDebt(address user, uint256 amount) internal {
        _debt[user] -= amount;
    }

    
    function _update(address from, address to, uint256 value) internal override {
        if (from != address(0) && balanceOf(from) < value + _debt[from]) {
            revert VasthavikamainaToken__DebtOverflow(from, _debt[from], value);
        }

        super._update(from, to, value);
    }

    function withdraw(uint256 amount) external onlyOwner nonReentrant {
        if(amount>totalCashOutFeesCollected){
            revert VasthavikamainaToken__WithDraw__Amount__Exceeds__Fee__Collected(amount,totalCashOutFeesCollected);
        }
        if(address(this).balance < amount){
            revert VasthavikamainaToken__Insufficient__Funds(amount,address(this).balance);
        }

        totalCashOutFeesCollected -= amount;
        (bool success, ) = owner().call{value: amount}("");
        if(!success){
            revert VasthavikamainaToken__Call__Failed();
        }
        emit Withdraw(owner(), amount);

    }
}