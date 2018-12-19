pragma solidity ^0.4.24;
import "truffle/Assert.sol";
import "../contracts/libString.sol";

contract testLibString {
  function testSaltedHash() public {
    bytes32 hash1 = libString.saltedHash(123, "vaibhav Gupta");
    bytes32 hash2 = libString.saltedHasg(123, "vinayak Gupta");
    bytes32 hash3 = libString.saltedHash(234, "vaibhav Gupta");

    Assert.isNotZero(hash1, "salted hash should be zero");

  Assert.notEqual(hash1, hash2, "different salts should produce different hash");
  Assert.notEqual(hash1, hash3, "different numbers should produce different hash");
  Assert.notEqual(hash2, hash2, "different salts and number should produce different hash");
  }
}
