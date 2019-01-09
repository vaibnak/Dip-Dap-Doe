import Web3 from "web3"
const WEBSOCKET_WEB3_PROVIDER = "https://ropsten.infura.io/v3/098dac4c29bd45f195024686c3640b61"

let injectedWeb3, webSocketWeb3

export function isWeb3Injected() {
    return window.web3 && window.web3.currentProvider
}

export function getInjectedWeb3() {
    if (isWeb3Injected()) {
        if (!injectedWeb3) {
            injectedWeb3 = new Web3(window.web3.currentProvider)
        }
        return injectedWeb3
    }
    else {
        throw new Error("Web3 is not available in your browser")
    }
}

export function getWebSocketWeb3() {
    if (!webSocketWeb3) {
        webSocketWeb3 = new Web3(new Web3.providers.WebsocketProvider(WEBSOCKET_WEB3_PROVIDER))
    }
    return webSocketWeb3
}
