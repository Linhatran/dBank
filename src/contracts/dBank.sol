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
  // pass address of token on the network as argument
  constructor(Token _token) public { // constructor is ran whenever contract is deployed to the network
    // create a local token variable and assign it to state token variable 
    token = _token;
  }

  function deposit() payable public {
    // reject deposit if it's already deposited
    require(isDeposited[msg.sender] == true, "Error: already deposited!");
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
    //check if msg.sender deposit status is true
    //assign msg.sender ether deposit balance to variable for event

    //check user's hodl time

    //calc interest per second
    //calc accrued interest

    //send eth to user
    //send interest in tokens to user

    //reset depositer data

    //emit event
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