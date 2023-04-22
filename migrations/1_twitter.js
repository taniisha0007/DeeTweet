var Twitter = artifacts.require("Twitter");

module.exports = function(deployer) {
  // deployment steps
  deployer.deploy(Twitter);
};