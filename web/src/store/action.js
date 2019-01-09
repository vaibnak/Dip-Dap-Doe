import getDipDappDoeInstance from "../contracts/dip-dap-doe"

export function fetchOpenGames() {
  const DipDapDoe = getDipDapDoeInstance(false)

  return (dispatch, getState) => {
    DipDapDoe.methods.getOpenGames().call().then(games => {
      return Promise.all(games.map(gameId => {
        return DipDapDoe.methods.getGameInfo(gameId).call()
               .then(gameData => {
                  gameData.id = gameId
                  return gameData
               })
      })).then(games => {
         dispatch({type: "SET", openGames: games})
      })
    })
  }
}
