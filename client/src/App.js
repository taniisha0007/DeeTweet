
import React, { useState,useEffect } from "react";
import Web3 from "web3";
import Twitter from "./contracts/Twitter.json";

function App() {
  const [loggedIn, setLoggedIn] = useState(false);
  const [web3, setWeb3] = useState(null);
  const [contract, setContract] = useState(null);
  const [accounts, setAccounts] = useState([]);
  const [latestTweets, setLatestTweets] = useState([]);
  const [userTweets, setUserTweets] = useState([]);

  const connect = async () => {
    if (window.ethereum) {
      try {
        //const provider = new Web3.providers.HttpProvider("HTTP://127.0.0.1:7545");
        const web3 = new Web3(window.ethereum);
        await window.ethereum.enable();
        const accounts = await web3.eth.getAccounts();
        setWeb3(web3);
        setAccounts(accounts);
        const networkId = await web3.eth.net.getId();
        const deployedNetwork = Twitter.networks[networkId];
        const contract = new web3.eth.Contract(
          Twitter.abi,
          deployedNetwork && deployedNetwork.address
        );
        setContract(contract);
        setLoggedIn(true);
      } catch (error) {
        console.error(error);
      }
    } else {
      window.alert("Please install MetaMask to use this dApp!");
    }
  };

  const logout = async () => {
    setLoggedIn(false);
    await contract.methods.log_out().send({ from: accounts[0] });
  };

  const tweet = async (content) => {
    await contract.methods.tweet(accounts[0], content).send({ from: accounts[0] });
  };

  const getLatestTweets = async (count) => {
    const latestTweets = await contract.methods.getLatestTweets(count).call();
    setLatestTweets(latestTweets);
  };

  const getUserTweets = async (userAddress, count) => {
    const userTweets = await contract.methods.getLatestofUser(userAddress, count).call();
    setUserTweets(userTweets);
  };

  return (
    <div>
      {loggedIn ? (
        <>
          <p>Logged in with Ethereum address: {accounts[0]}</p>
          <button onClick={logout}>Log out</button>
          <div>
            <h2>Latest tweets</h2>
            <button onClick={() => getLatestTweets(10)}>Get latest 10 tweets</button>
            <ul>
              {latestTweets.map((tweet) => (
                <li key={tweet.id}>
                  <p>{tweet.content}</p>
                  <p>Author: {tweet.author}</p>
                  <p>Created at: {tweet.createdAt}</p>
                </li>
              ))}
            </ul>
          </div>
          <div>
            <h2>Your tweets</h2>
            <button onClick={() => getUserTweets(accounts[0], 10)}>Get latest 10 tweets</button>
            <ul>
              {userTweets.map((tweet) => (
                <li key={tweet.id}>
                  <p>{tweet.content}</p>
                  <p>Created at: {tweet.createdAt}</p>
                </li>
              ))}
            </ul>
            <form
              onSubmit={(event) => {
                event.preventDefault();
                const content = event.target.elements[0].value;
                tweet(content);
              }}
            >
              <label>
                Tweet:
                <input type="text" name="content" />
              </label>
              <button type="submit">Tweet</button>
            </form>
          </div>
        </>
      ):<></>
      }
    </div>)
}
export default App;


