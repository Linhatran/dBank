import { Tabs, Tab } from 'react-bootstrap';
import dBank from '../abis/dBank.json';
import React, { Component, useEffect, useState } from 'react';
import Token from '../abis/Token.json';
import dbankLogo from '../dbank.png';
import Web3 from 'web3';
import './App.css';

const App = ({ dispatch }) => {
  const [web3, setWeb3] = useState(null);
  const [account, setAccount] = useState('');
  const [token, setToken] = useState(null);
  const [dbank, setDbank] = useState(null);
  const [balance, setBalance] = useState(0);
  const [dbankAddress, setDbankAddress] = useState(null);
  const [depositAmount, setDepositAmount] = useState(0);

  const loadBlockChainData = async (dispatch) => {
    if (typeof window.ethereum) {
      const web3 = new Web3(window.ethereum);
      const netId = await web3.eth.net.getId();
      if (web3) setWeb3(web3);

      const accounts = await web3.eth.getAccounts();

      if (accounts[0]) {
        setAccount(accounts[0]);
        const balance = await web3.eth.getBalance(accounts[0]);
        setBalance(balance);
      } else {
        window.alert('Please connect to Metamask');
      }

      try {
        // Create a new Token
        const token = new web3.eth.Contract(
          Token.abi,
          Token.networks[netId].address
        );
        token && setToken(token);
        // Create new bank
        const bank = new web3.eth.Contract(
          dBank.abi,
          dBank.networks[netId].address
        );
        const bankAddress = dBank.networks[netId].address;
        bank && setDbank(bank) && setDbankAddress(bankAddress);
      } catch (e) {
        console.log('Error', e);
        window.alert('Contracts not deployed to the current network');
      }
    } else {
      window.alert('Please install Metamask');
    }
  };

  useEffect(() => {
    loadBlockChainData(dispatch);
  }, [dispatch]);

  const deposit = async (amount) => {
    if (dbank) {
      try {
        dbank.methods
          .deposit()
          .send({ value: amount.toString(), from: account });
      } catch (e) {
        console.log('Deposit Error:', e);
        window.alert(
          'Something went wrong while depositng your ETH. Please try again!'
        );
      }
    }
  };
  const withdraw = async (e) => console.log('withdraw', e);

  return (
    <div className='text-monospace'>
      <nav className='navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow'>
        <a
          className='navbar-brand col-sm-3 col-md-2 mr-0'
          href='http://www.dappuniversity.com/bootcamp'
          target='_blank'
          rel='noopener noreferrer'
        >
          <img src={dbankLogo} className='App-logo' alt='logo' height='32' />
          <b>dBank</b>
        </a>
      </nav>
      <div className='container-fluid mt-5 text-center'>
        <br></br>
        <h1>Welcome to dBank!</h1>
        <h2>Your account is: {account}</h2>
        <br></br>
        <div className='row'>
          <main role='main' className='col-lg-12 d-flex text-center'>
            <div className='content mr-auto ml-auto'>
              <Tabs defaultActiveKey='profile' id='uncontrolled-tab-example'>
                <Tab eventKey='deposit' title='Deposit'>
                  <div>
                    <p>
                      How much you want to deposit?{' '}
                      <small>(min. amount is 0.01 ETH)</small>
                    </p>

                    <p> Only 1 deposit is possible at a time!</p>
                    <form
                      onSubmit={(e) => {
                        e.preventDefault();
                        deposit(depositAmount);
                      }}
                    >
                      <div className='form-group mr-sm-2'>
                        <br></br>
                        <input
                          id='depositAmount'
                          type='number'
                          step='0.01'
                          min='0'
                          placeholder='amount...'
                          className='form-control form-control-md'
                          required
                          onChange={(e) =>
                            setDepositAmount(e.target.value * 10 ** 18)
                          }
                        />
                      </div>
                      <button type='submit' className='btn btn-primary'>
                        DEPOSIT
                      </button>
                    </form>
                  </div>
                </Tab>
                <Tab eventKey='withdraw' title='Withdraw'>
                  <div>
                    <br></br> Do you want to withdraw and earn interest in
                    tokens?
                  </div>
                </Tab>
              </Tabs>
            </div>
          </main>
        </div>
      </div>
    </div>
  );
};
export default App;
