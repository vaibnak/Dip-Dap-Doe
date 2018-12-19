pragma solidity ^0.4.20;
import "./libString.sol";

contract DipDapDoe {
  //events
  event gameCreated(uint32 indexed gameId);
  event gameAccepted(uint32 indexed gameId);
  event gameStarted(uint32 indexed gameId);
  event positionMarked(uint32 indexed gameId);
  event gameEnded(uint32 gameId);

  //callable
  function getOpenGames() public view returns (uint32[]) {

  }

  function getGameInfo(uint32 gameId) public view returns (uint8[9] cells, uint8 status, uint amount, string nick1, string nick2) {

  }

  //operations

  function createGame(string randomNumberHash, string nick) public payable returns (uint32 gameId) {
    return 0;
  }

  function acceptGame(uint32 gameid, uint8 randomNumber, string nick) public payable {
    revert();
  }

  function confirmGame(uint32 gameId, uint8 orgRandomNumber, bytes32 originalSalt) {

  }

  function markPosition(uint32 gameId, uint8 cell) public {
    revert();
  }

  function hashNumber(uint8 randomNumber, string salt) public pure returns (bytes32) {
    return " ";
  }

  //Default
  function () public payable {
    revert();
  }

}
