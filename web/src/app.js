import React, {Component} from "react"
import { Route, Switch, Redirect } from 'react-router-dom'
import Web3 from "web3"
import { connect } from 'react-redux'


const MainView = () => <div>Main View</div>
const NewGameView = () => <div>New Game View</div>
const GameView = () => <div>Game View</div>

const LoadingView = () => <div>Loading View</div>
const MessageView = props => <div>{props.message || ""}</div>

class App extends Component {
  constructor(props) {
    super(props)

    this.state = {
      loading: true,
      unsupported: false,
      connected: false,
      network: null,
      accounts: []
    }
  }

  componentDidMount() {
    if(window.web3 && window.web3.currentProvider) {
      window.web3 = new Web3(window.web3.currentProvider)

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
