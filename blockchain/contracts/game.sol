pragma solidity ^0.4.24;
import "./libString.sol";

contract DipDapDoe {

//dataModel
struct Game {
  //this game`s position in getOpenGames[]
  uint32 openListIndex;

  uint8[9] cells;
 //0 => not started, 1 => player1 , 2 => player2 ,
 //10 => draw, 11 => player1 wins, 12 => player2 wins
  uint8 status;

  //amount of money each user has sent
  uint amount;

  address[2] players;
  string[2] nicks;
  uint lastTransaction; //timestamp => blocknumber
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
  event gameAccepted(uint32 indexed gameId, address indexed opponent);
  event gameStarted(uint32 indexed gameId, address indexed opponent);
  event positionMarked(uint32 indexed gameId, address indexed opponent);
  event gameEnded(uint32 gameId, address indexed opponent);

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

  function getGameTimeStamp(uint32 gameId) public view returns(uint256 lastTransaction){
    return (gamesData[gameId].lastTransaction);
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

  function createGame(bytes32 randomNumberHash, string nick) public payable returns (uint32 gameId) {
   require(nextGameId+1 > nextGameId);

   gamesData[nextGameId].openListIndex = uint32(openGames.length);
   gamesData[nextGameId].creatorHash = randomNumberHash;
   gamesData[nextGameId].amount = msg.value;
   gamesData[nextGameId].nicks[0] = nick;
   gamesData[nextGameId].players[0] = msg.sender;
   gamesData[nextGameId].lastTransaction = now;
   openGames.push(nextGameId);

   gameId = nextGameId;
   emit gameCreated(nextGameId);

    nextGameId++;
  }

  function acceptGame(uint32 gameId, uint8 randomNumber, string nick) public payable {
    require(gameId < nextGameId);
    require(gamesData[gameId].players[0] != 0x0);
    require(msg.value == gamesData[gameId].amount);
    require(gamesData[gameId].players[1] == 0x0);
    require(gamesData[gameId].status == 0);

    gamesData[gameId].guestRandomNumber = randomNumber;
    gamesData[gameId].nicks[1] = nick;
    gamesData[gameId].players[1] = msg.sender;
    gamesData[gameId].lastTransaction = now;

    emit gameAccepted(gameId, gamesData[gameId].players[0]);

    //remove from open list
     uint32 idToDelete = uint32(gamesData[gameId].openListIndex);
     openGames[idToDelete] = openGames[openGames.length-1];
     gamesData[gameId].openListIndex = idToDelete;
     openGames.length--;
  }

  function confirmGame(uint32 gameId, uint8 orgRandomNumber, string originalSalt) {
     require(gameId < nextGameId);
     require(gamesData[gameId].players[0] == msg.sender);
     require(gamesData[gameId].players[1] != 0x0);
     require(gamesData[gameId].status == 0);

     bytes32 computedHash = saltedHash(orgRandomNumber, originalSalt);
     if(computedHash != gamesData[gameId].creatorHash){
       gamesData[gameId].status = 12;
       emit gameEnded(gameId, msg.sender);
       emit gameEnded(gameId, gamesData[gameId].players[1]);
       return;
     }

     gamesData[gameId].lastTransaction = now;
     //defining the starting player
     if((orgRandomNumber ^ gamesData[gameId].guestRandomNumber) & 0x01 == 0){
       gamesData[gameId].status = 1;
       emit gameStarted(gameId, gamesData[gameId].players[1]);
     }else {
       gamesData[gameId].status = 2;
       emit gameStarted(gameId, gamesData[gameId].players[1]);
     }

  }

  function markPosition(uint32 gameId, uint8 cell) public {
    require(gameId < nextGameId);
    require(cell <= 8);

    uint8 [9]storage cells = gamesData[gameId].cells;
    require(cells[cell] == 0);

    if(gamesData[gameId].status == 1) {
      require(gamesData[gameId].players[0] == msg.sender);

      cells[cell] = 1;
      emit positionMarked(gameId, gamesData[gameId].players[1]);
    }else if(gamesData[gameId].status == 2){
      require(gamesData[gameId].players[1] == msg.sender);
      cells[cell] = 2;
      emit positionMarked(gameId, gamesData[gameId].players[0]);
    }else {
      revert();
    }

    gamesData[gameId].lastTransaction = now;


        if((cells[0] & cells [1] & cells [2] != 0x0) || (cells[3] & cells [4] & cells [5] != 0x0) ||
        (cells[6] & cells [7] & cells [8] != 0x0) || (cells[0] & cells [3] & cells [6] != 0x0) ||
        (cells[1] & cells [4] & cells [7] != 0x0) || (cells[2] & cells [5] & cells [8] != 0x0) ||
        (cells[0] & cells [4] & cells [8] != 0x0) || (cells[2] & cells [4] & cells [6] != 0x0)) {
            // winner
            gamesData[gameId].status = 10 + cells[cell];  // 11 or 12
            emit gameEnded(gameId, gamesData[gameId].players[0]);
            emit gameEnded(gameId, gamesData[gameId].players[1]);
        }
        else if(cells[0] != 0x0 && cells[1] != 0x0 && cells[2] != 0x0 &&
            cells[3] != 0x0 && cells[4] != 0x0 && cells[5] != 0x0 && cells[6] != 0x0 &&
            cells[7] != 0x0 && cells[8] != 0x0) {
            // draw
            gamesData[gameId].status = 10;
            emit gameEnded(gameId, gamesData[gameId].players[0]);
            emit gameEnded(gameId, gamesData[gameId].players[1]);
        }
        else {
            if(cells[cell] == 1){
                gamesData[gameId].status = 2;
            }
            else if(cells[cell] == 2){
                gamesData[gameId].status = 1;
            }
            else {
                revert();
            }
       }
  }

  function saltedHash(uint8 randomNumber, string salt) public pure returns (bytes32) {
    return libString.saltedHash(randomNumber, salt);
  }

  //Default
  function () public payable {
    revert();
  }

}
