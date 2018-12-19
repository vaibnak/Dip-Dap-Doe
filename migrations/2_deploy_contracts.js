const libString = artifacts.require("./libString.sol");
const game = artifacts.require("./game.sol");

module.exports = function(deployer) {
  deployer.deploy(libString);
  deployer.link(libString, game);
  deployer.deploy(game);
};
