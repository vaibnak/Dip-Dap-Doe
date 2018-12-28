const dipDapDoe = artifacts.require("./DipDapDoe.sol");
const libString = artifacts.require("./libString");

let gameInstance, libStringInstance;

contract('dipDapDoe', function(accounts) {
  it("should be deployed", async function() {
    gameInstance = await dipDapDoe.deployed();
    assert.isOk(gameInstance, "instance should not be null");
    assert.equal(typeof gameInstance, "object", "instance should be an object");

    libStringInstance = await libString.deployed();
    assert.isOk(libStringInstance, "instance should not be null");
    assert.equal(typeof libStringInstance, "object", "instance should be an object");
  });

  it("should start with not games at beginning", async function(){
    let gamesAddr = await gameInstance.getOpenGames.call();
    assert.deepEqual(gamesAddr, [], "shuld have zero games at beginning");
  });

  it("should use the saltedHash function from the library", async function(){
    let hash1 = await libStringInstance.saltedHash.call(123, "my salt 1");
     let hashA = await gameInstance.saltedHash.call(123, "my salt 1");

     let hash2 = await libStringInstance.saltedHash.call(123, "my salt 2");
     let hashB = await gameInstance.saltedHash.call(123, "my salt 2");

     let hash3 = await libStringInstance.saltedHash.call(234, "my salt 1");
     let hashC = await gameInstance.saltedHash.call(234, "my salt 1");

     assert.equal(hash1, hashA, "Contract hashes should match the library output")
     assert.equal(hash2, hashB, "Contract hashes should match the library output")
     assert.equal(hash3, hashC, "Contract hashes should match the library output")

     assert.notEqual(hash1, hash2, "Different salt should produce different hashes");
     assert.notEqual(hash1, hash3, "Different numbers should produce different hashes");
assert.notEqual(hash2, hash3, "Different numbers and salt should produce different hashes");
  })

})
