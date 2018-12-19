pragma solidity ^0.4.24;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/game.sol";

contract testGame {
  DipDapDoe gameInstance;

  constructor() public {
    gameInstance = DipDapDoe(DeployedAddresses.game());
  }

  function testInitialEmpty() public {
    Assert.equal(gameInstance.getOpenGames().length, 0, "the gamearray should be empty initially");
  }

  function testHashingFunction() public {
    bytes32 hash1 = gameInstance.saltedHash(123, "my salt goes here");
    bytes32 hashA = libString.saltedHash(123, "my salt goes here");

    bytes32 hash2 = gameInstance.saltedHash(123, "my salt 2 goes here");
    bytes32 hashB = libString.saltedHash(123, "my salt 2 goes here");

    bytes32 hash3 = gameInstance.saltedHash(234, "my salt goes here");
    bytes32 hashC = libString.saltedHash(234, "my salt goes here");

    Assert.isNotZero(hash1, "salt hash should be valid");

    Assert.equal(hash1, hashA, "hashes should be equal");
    Assert.equal(hash2, hashB, "hashes should be equal");
    Assert.equal(hash2, hashB, "hashes should be equal");


    Assert.notEqual(hash1, hash2, "different salts should produce different hash");
Assert.notEqual(hash1, hash3, "different numbers should produce different hash");
    Assert.notEqual(hash2, hash3, "different salts and numbers should produce different hash");
  }
}
