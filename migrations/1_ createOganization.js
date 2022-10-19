/*
Create an Oganization
*/
const keeper = require('./keeper');
const DaoAcc = artifacts.require('./organization/DaoAccessControl');
const DaoRecord = artifacts.require('./organization/DaoRecord');
const DaoToken = artifacts.require('./organization/DaoToken');
const TokenName = 'Organization Token';
const TokenTokenSymbol = 'OTK';

module.exports = async function (deployer) {
  // Command Truffle to deploy the Smart Contract
  await deployer.deploy(DaoAcc);
  keeper.daoAccessControl = await DaoAcc.deployed();
  await deployer.deploy(DaoRecord, keeper.daoAccessControl.address);
  keeper.daoRecord = await DaoRecord.deployed();
  await deployer.deploy(
    DaoToken,
    keeper.daoAccessControl.address,
    TokenName,
    TokenTokenSymbol
  );
  keeper.daoToken = await DaoToken.deployed();

  console.log(
    'Organiszation Acccess Control create at address: ',
    keeper.daoAccessControl.address
  );
  console.log(
    'Organiszation Token create at address: ',
    keeper.daoToken.address
  );
  console.log(
    'Organiszation Recode create at address: ',
    keeper.daoRecord.address
  );
};
