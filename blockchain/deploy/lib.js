const fs = require('fs');
const path = require('path')
const Web3 = require("web3")
const HDWalletProvider = require('truffle-hdwallet-provider')

const { PROVIDER_URI, WALLET_MNEMONIC } = require("../env.json")
const provider = new HDWalletProvider(WALLET_MNEMONIC, PROVIDER_URI)
const web3 = new Web3(provider)

async function deploy(web3, fromAccount, ABI, bytecode, ...params) {
  const contract = new web3.eth.Contract(JSON.parse(ABI));
  console.log(bytecode);
  const estimatedGas = await contract.deploy({data:   bytecode, arguments: params}).estimateGas();

  const tx = await contract.deploy({ data:   bytecode, arguments: params}).send({from: fromAccount, gas: estimatedGas+200});

  return tx.options.address;

}

async function deployDapp() {
  const accounts = await web3.eth.getAccounts();

  console.log(`the account used to deploy is ${accounts[0]}`);
  console.log("current balance: ", await web3.eth.getBalance(accounts[0], "\n"));

    var libStringAbi = fs.readFileSync(path.resolve(__dirname, "..", "build", "libString_sol_libString.abi")).toString();
    var libStringBytecode = fs.readFileSync(path.resolve(__dirname, "..", "build", "libString_sol_libString.bin")).toString();
    var dipDappDoeAbi = fs.readFileSync(path.resolve(__dirname, "..", "build", "game_sol_DipDapDoe.abi")).toString();
    var dipDappDoeBytecode = fs.readFileSync(path.resolve(__dirname, "..", "build", "game_sol_DipDapDoe.bin")).toString();

    try {
        console.log("Deploying LibString...");
        libStringBytecode = "0x"+libStringBytecode;
        const libStringAddress = await deploy(web3, accounts[0], libStringAbi, libStringBytecode);
        console.log(`- LibString deployed at ${libStringAddress}\n`);

        const libPattern = /__libString.sol:libString_______________/g;
        // console.log("dipDappDoeBytecode: ",dipDappDoeBytecode);
        var linkedDipDappDoeBytecode = dipDappDoeBytecode.replace(libPattern, libStringAddress.substr(2));
        if (linkedDipDappDoeBytecode.length != dipDappDoeBytecode.length) {
            throw new Error("The linked contract size does not match the original");
        }

        console.log("Deploying DipDappDoe...");
        linkedDipDappDoeBytecode = "0x"+linkedDipDappDoeBytecode;
        const dipDappDoeAddress = await deploy(web3, accounts[0], dipDappDoeAbi, linkedDipDappDoeBytecode, 0);
        console.log(`- DipDappDoe deployed at ${dipDappDoeAddress}`);
    }
    catch (err) {
        console.error("\nUnable to deploy:", err.message, "\n");
        process.exit(1);
    }
    process.exit();
}

module.exports = {
    deployDapp
}
