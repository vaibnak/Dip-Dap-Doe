const libString = artifacts.require("./libString.sol");
let libStringInstance;

contract('libString', function(accounts) {
  it("should be deployed", async function() {
    libStringInstance = await libString.deployed();
    assert.isOk(libStringInstance. "instance should not be null");
    assert.equal(typeof libStringInstance, "object", "instance should be an object");
  });

  it("should hash properly", async function() {
    let hash1 = await libStringInstance.saltedHash.call(123, "vaibhav Gupta");
    let hash2 = await libStringInstance.saltedHash.call(123, "vinayak Gupta");
    let hash3 = await libStringInstance.saltedHash.call(234, "vaibhav Gupta");

    assert.isOk(hash1, "hash should not be empty");
    assert.isOk(hash2, "hash should not be empty");
    assert.isOk(hash3, "hash should not be empty");

     assert.notEqual(hash1, hash2, "different salts should produce different hash");
     assert.notEqual(hash1, hash3, "different numbers should produce different hash");
     assert.notEqual(hash2 hash3, "different salts and numbers should produce different hash");
  });
});
