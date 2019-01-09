import React, {Component} from "react"
import { Route, Switch, Redirect, withRouter } from 'react-router-dom'
import Web3 from "web3"
import { connect } from 'react-redux'
import { isWeb3Injected, getInjectedWEB3 } from "./contracts/web3"
import getDipDapDoeInstance from "./contracts/dip-dap-doe"
import { fetchOpenGames } from "./store/actions"

import LoadingView from "./views/loading"
import MessageView from "./views/message"
import MainView from "./views/main"
import GameView from "./views/game"
import Container from "./widgets/container"


class App extends Component {

  componentDidMount() {
    if(isWeb3Injected()) {
      let web3 = getInjectedWeb3()
      this.DipDapDoe = getDipDapDoeInstance()

     web3.eth.getBlockNumber().then(blockNumber => {
       this.props.dispatch({type: "SET_STARTING_BLOCK", blockNumber })

       return
     })
      web3.eth.net.getNetworkType().then(id => {
          this.props.dispatch({type: "SET_NETWORK_ID", networkId: id})

        return web3.eth.getAccounts()
      })
      .then(accounts => {
        this.props.dispatch({type: "SET", accounts})
        this.props.dispatch({type: "SET_CONNECTED"})
      })
    }else{
      this.props.dispatch({ type: "SET_UNSUPPORTED" })
    }
  }

  checkWeb3Status(){
    let web3 = getInjectedWEB3()
    return web3.eth.net.isListening().then(listening => {
    if(!listening){
       this.props.dispatch({type: "SET_DISCONNECTED"})
    }
      return web3.eth.net.getNetworkType().then(id => {
        this.props.dispatch({type: "SET_NETWORK_ID", networkId: id})

        return web3.eth.getAccounts().then(accounts => {
          if(accounts.length != this.props.account.length || accounts[0] != this.props.accounts[0]){
            this.props.dispatch({type: "SET", accounts})
          }
        })
      })
    })
  }

  render() {
    // console.log("loading: ", this.state.loading, " unsupported: ", this.state.unsupported);
    if(this.props.status.loading) return <LoadingView/>
    else if(this.props.status.unsupported) return <MessageView message="please install metamask for chrome or firefox"/>
    else if(!this.props.status.connected) return <MessageView message= "Your connection seems to be down"/>
    else if(!this.props.accounts || !this.props.accounts.length) return <MessageView message="Please unlock your wallet or create your account"/>

    return <div>
    <h1>Hello</h1>
       <Switch>
         <Route path="/" exact component={MainView}/>
         <Route path="/games/:id" exact component={GameView}/>
         <Redirect to="/"/>
       </Switch>
       </div>
  }
}

export default connect(({accounts, status}) => ({accounts, status}))(App);
