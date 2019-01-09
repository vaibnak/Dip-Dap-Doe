import { getInjectedWeb3, getWebSocketWeb3 } from "./web3"
import dipDappDoeAbi from "./DipDapDoe.json"
const CONTRACT_ADDRESS = "0x4B21990964796a1aA4B62381F4B703b2934DecDD"

export default function(userBrowserWeb3 = false) {
  let web3
  if(userBrowserWeb3){
    web3 = getInjectedWeb3()
  }
  else{
    web3 = getWebSocketWeb3()
  }
  return new web3.eth.Contract(dipDappDoeAbi, CONTRACT_ADDRESS)
}
