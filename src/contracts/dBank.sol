// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import "./Token.sol";

contract dBank {

  // store Token in private state variable 
  Token private token;
  // add mappings to store eth balance (mapping: key/value pair storage)
  mapping(address => uint) public etherBalanceOf;
  mapping(address => uint) public depositStart;
  mapping(address => bool) public isDeposited;


  // add events
  event Deposit(address indexed user, uint etherAmount, uint timeStart);
  event Withdraw(address indexed user, uint etherAmount, uint depositTime, uint interest);

  // pass address of token on the network as argument
  constructor(Token _token) public { // constructor is ran whenever contract is deployed to the network
    // create a local token variable and assign it to state token variable 
    token = _token;
  }

  function deposit() payable public {
    // reject deposit if it's already deposited
    require(isDeposited[msg.sender] == false, "Error: already deposited!");
    require(msg.value >= 1e16, "Error: deposit must be >= 0.01 ETH");
    // store address of person who deposits/makes transaction as key, transaction eth amount as value
    // get current sender's balance (existing balance + transaction value)
    etherBalanceOf[msg.sender] = etherBalanceOf[msg.sender] + msg.value;

    // get deposit start time using timestamp on the block
    depositStart[msg.sender] = depositStart[msg.sender] + block.timestamp;

    // set msg.sender deposit status to true
    isDeposited[msg.sender] = true;

    // emit Deposit event
    emit Deposit(msg.sender, msg.value, block.timestamp);
  }

  function withdraw() public {
    // check if msg.sender deposit status is true
    require(isDeposited[msg.sender] == true, "Error: no deposit exists!");

    // assign msg.sender ether deposit balance to variable for event
    uint userBalance = etherBalanceOf[msg.sender];

    // get user's deposit time
    uint depositTime = block.timestamp - depositStart[msg.sender];

    // calc interest per second: 10% APY per sec for minimum deposit of 0.01 ETH:  1e15 x (10% x 0.01 ETH)/ 31577600 (seconds) = 31668017
    uint interestPerSecond = 31668017 * (userBalance / 1e16);

    // calc accrued interest
    uint interest = interestPerSecond * depositTime;

    // send eth back to user
    msg.sender.transfer(userBalance);
    // send interest in tokens to user
    token.mint(msg.sender, interest);

    // reset depositer data in the bank
    etherBalanceOf[msg.sender] = 0;
    depositStart[msg.sender] = 0;
    isDeposited[msg.sender] = false;

    // emit event
    emit Withdraw(msg.sender, userBalance, depositTime, interest);
  }

  function borrow() payable public {
    //check if collateral is >= than 0.01 ETH
    //check if user doesn't have active loan

    //add msg.value to ether collateral

    //calc tokens amount to mint, 50% of msg.value

    //mint&send tokens to user

    //activate borrower's loan status

    //emit event
  }

  function payOff() public {
    //check if loan is active
    //transfer tokens from user back to the contract

    //calc fee

    //send user's collateral minus fee

    //reset borrower's data

    //emit event
  }
}