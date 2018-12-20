pragma solidity ^0.4.20;
import "./libString.sol";

contract DipDapDoe {

//dataModel
struct Game {
  //this game`s position in getOpenGames[]
  uint32 listIndex;

  uint8[9] cells;
 //0 => not started, 1 => player1 , 2 => player2 ,
 //10 => draw, 11 => player1 wins, 12 => player2 wins
  uint8 status;

  //amount of money each user has sent
  uint amount;

  address[2] players;
  string[2] nicks;
  uint[2] lastTransactions; //timestamp => blocknumber
  bool[2] withdrawn;

  bytes32 creatorHash;
  uint8 guestRandomNumber;

}

//list of active game indices
uint32[] openGames;

//indexed struct
mapping (uint32 => Game) gamesData;
uint32 nextGameId;
uint16 public timeout;



  //events
  event gameCreated(uint32 indexed gameId);
  event gameAccepted(uint32 indexed gameId);
  event gameStarted(uint32 indexed gameId);
  event positionMarked(uint32 indexed gameId);
  event gameEnded(uint32 gameId);

  constructor(uint16 givenTimeout) public {
    if(givenTimeout != 0){
      timeout = givenTimeout;
    }else{
      timeout = 10 minutes;
    }
  }

  //callable
  function getOpenGames() public view returns (uint32[]) {
       return openGames;
  }

  function getGameInfo(uint32 gameId) public view returns (uint8[9] cells, uint8 status, uint amount, string nick1, string nick2) {
       return (
         gamesData[gameId].cells,
         gamesData[gameId].status,
         gamesData[gameId].amount,
         gamesData[gameId].nicks[0],
         gamesData[gameId].nicks[1]
         );
  }

  function getGameTimeStamp(uint32 gameId) public view returns(uint lastTransaction){
    return (gameData[gameId].lastTransaction);
  }

  function getGamePlayers(uint32 gameId) public view
  returns (address player1, address player2) {
    return (
      gamesData[gameId].players[0],
      gamesData[gameId].players[1]
      );
  }

  function getGameWithdrawals(uint32 gameId) public view
  returns (bool player1, bool player2) {
    return (
      gamesData[gameId].withdrawn[0],
      gamesData[gameId].withdrawn[1]
      );
  }

  //operations

  function createGame(string randomNumberHash, string nick) public payable returns (uint32 gameId) {
   require(nextGameID+1 > nextGameId);

   gamesData[nextGameId].openListIndex = uint32(openGames.length);
   gamesData[nextGameID].creatorHash = randomNumberHash;
   gamesData[nextGameID].amount = msg.value;
   gamesData[nextGameID].nicks[0] = nick;
   gamesData[nextGameID].players[0] = msg.sender;
   gamesData[nextGameID].lastTransaction = now;
   openGames.push(nextGameId);

   gameId = nextGameId;
   emit gameCreated(nextGameId);

    nextGameId++;
  }

  function acceptGame(uint32 gameid, uint8 randomNumber, string nick) public payable {
    revert();
  }

  function confirmGame(uint32 gameId, uint8 orgRandomNumber, bytes32 originalSalt) {
     require(gameId < nextGameId);
     require(gamesData[gameId].players[0] == msg.sender);
     require(gamesData[gameId].players[1] != 0x0);
     require(gamesData[gameId].status == 0);

     bytes32 computedHash = saltedHash(orgRandomNumber, originalSalt);
     if(computedHash != gamesData[gameId].creatorHash){
       gamesData[gameId].status = 12;
       emit gameEnded(gameId, msg.sender);
       emit gameEnded(gameid, gamesData[gameId].players[1]);
       return;
     }

     gamesData[gameId].lastTransaction = now;
     //defining the starting player
     if((orgRandomNumber ^ gamesData[gameId].guestRandomNumber) & 0x01 == 0){
       gamesData[gameId].status = 1;
       emit gameStarted(gameId, gamesData[gameId].players[1]);
     }else {
       gameData[gameId].status = 2;
       emit gameStarted(gameId, gameData[gameId].players[1]);
     }

  }

  function markPosition(uint32 gameId, uint8 cell) public {
    revert();
  }

  function saltedHash(uint8 randomNumber, string salt) public pure returns (bytes32) {
    return " ";
  }

  //Default
  function () public payable {
    revert();
  }

}
