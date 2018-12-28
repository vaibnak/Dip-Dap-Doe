const fs = require('fs');
const path = require('path');
const Web3 = require('web3');
const HDWalletProvider = require('truffle-hdwallet-provider');

const { PROVIDER_URI, WALLET_MNEMONIC } = require("../env.json");
const provider = new HDWalletProvider(WALLET_MNEMONIC, PROVIDER_URI);
const web3 = new Web3(provider);

const CONTRACT_ADDRESS = "0x4B21990964796a1aA4B62381F4B703b2934DecDD";

async function startGame() {
  const accounts = await web3.eth.getAccounts();

  const dipDappDoeAbi = fs.readFileSync(path.resolve(__dirname, "..", "build", "game_sol_DipDapDoe.abi")).toString();

  try{
    const dipDappDoeInstance = new web3.eth.Contract(JSON.parse(dipDappDoeAbi), CONTRACT_ADDRESS);

    const hash = await dipDappDoeInstance.methods.saltedHash(100, "initial salt").call();
    const tx = await dipDappDoeInstance.methods.createGame(hash, "vaibhav").send({ from: accounts[0], value: web3.utils.toWei("0.001", "ether")});
    console.log(tx.events);
    const gameIdx = tx.events.gameCreated.returnValues.gameId;
    console.log("Game Created", gameIdx);
    console.log(await dipDappDoeInstance.methods.getGameInfo(gameIdx).call());
  }
catch(err) {
  console.error("\n Unable to deploy", err.message, "\n");
  process.exit(1);
}
}

startGame();
