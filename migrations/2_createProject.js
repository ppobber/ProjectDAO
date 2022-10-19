/*
Create an Oganization
*/
const keeper = require('./keeper');
const DaoAcc = artifacts.require('./organization/DaoAccessControl');
const DaoRecord = artifacts.require('./organization/DaoRecord');
const DaoToken = artifacts.require('./organization/DaoToken');
const ProjectAcc = artifacts.require('./project-name1/ProjectAccessControl');
const ProjectRecord = artifacts.require('./project-name1/ProjectRecord');
const ProjectToken = artifacts.require('./project-name1/ProjectToken');

const TokenName = 'Project Token';
const TokenTokenSymbol = 'PTK';
const ProjectAdmin = 'Zoe';
const ProjectAdminEmail = 'Zoe@email.com';

module.exports = async function (deployer) {
  // Command Truffle to deploy the Smart Contract
  const DaoAccIns = await DaoAcc.deployed();
  await deployer.deploy(
    ProjectAcc,
    DaoAccIns.address,
    ProjectAdmin,
    ProjectAdminEmail
  );
  keeper.projectAccessControl = await ProjectAcc.deployed();
  await deployer.deploy(ProjectRecord, keeper.projectAccessControl.address);
  keeper.projectRecord = await ProjectRecord.deployed();
  await deployer.deploy(
    ProjectToken,
    keeper.projectAccessControl.address,
    TokenName,
    TokenTokenSymbol
  );
  keeper.projectToken = await ProjectToken.deployed();

  console.log(
    'Project Acccess Control create at address: ',
    keeper.projectAccessControl.address
  );
  console.log('Project Token create at address: ', keeper.projectToken.address);
  console.log(
    'Project Record create at address: ',
    keeper.projectRecord.address
  );
};
