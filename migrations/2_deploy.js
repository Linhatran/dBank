const Token = artifacts.require('Token');
const dBank = artifacts.require('dBank');

module.exports = async function (deployer) {
  // deploy Token contract to the network using truffle deployer
  await deployer.deploy(Token);

  // fetch a token from the network
  const token = await Token.deployed();

  // deploy dBank contract to the network using truffle deployer
  await deployer.deploy(dBank, token.address);

  // fetch for an instance of dBank from the network
  const dbank = await dBank.deployed();

  // transfer mintership from owner to bank for future mintation
  await token.transferMinterRole(dbank.address);
};

