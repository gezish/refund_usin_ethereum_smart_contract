const pay_geo = artifacts.require("pay_geo");
  
module.exports = function (deployer) {
  deployer.deploy(pay_geo);
};