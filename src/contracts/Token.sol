// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
/** msg: global var inside Ethereum 
 */
contract Token is ERC20 {
  // initialize a public minter variable with address data type
  address public minter;

  // add minter changed event
  event MinterChanged(address indexed from, address to);

  constructor() public payable ERC20("Decentralized Bank Currency", "DCB") { // payable so we can send funds
    // assign minter to sender
    minter = msg.sender;
  }

  // add ability to transfer minter role eg: from deployer => bank
  function transferMinterRole(address dBank) public {
    require(msg.sender == minter, "Error: mesg.sender is not a minter, only a minter can transfer mintership");
    minter = dBank;

    emit MinterChanged(msg.sender, dBank);
    return true;
  }

  // create a mint wrapper to ensure that only minter above can mint token
  function mint(address account, uint256 amount) public { // create a new token = minting
    //check if msg.sender have minter role
    require(msg.sender == minter, "Error: msg.sender does not have minter role");
		_mint(account, amount); // inherits _mint from ERC20
	}
}