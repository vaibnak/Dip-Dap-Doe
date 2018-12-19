pragma solidity ^0.4.24;

library libString {
  function saltedHash(uint8 randomNumber, string salt) public pure returns (bytes32) {
    bytes memory bNum = new bytes(1);
    bNum[0] = byte(randomNumber);

    return keccak256(bytes(concat(string(bNum), salt)));
  }
}

function concat(string first, string second) internal returns(string) {
  bytes memory f = bytes(first);
  bytes memory s = bytes(second);
  bytes memory fstr = new str(f.length + s.length);
  bytes memeory result = bytes(fstr);

  uint k = 0;
   for(uint i = 0;i < f.length; i++){
     result[k++] = f[i];
   }

   for(uint i = 0;i < s.length; i++){
     result[k++] = s[i];
   }

   return string(result);
}
