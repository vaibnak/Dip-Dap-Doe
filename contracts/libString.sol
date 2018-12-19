pragma solidity ^0.4.24;

library libString {
  function saltedHash(uint8 randomNumber, string salt) public pure returns (bytes32) {
    bytes memory bNum = new bytes(1);
    bNum[0] = byte(randomNumber);

    return keccak256(bytes(concat(string(bNum), salt)));
  }
}
