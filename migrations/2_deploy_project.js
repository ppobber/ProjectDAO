/*
Create an Oganization
*/

const fs = require('fs-extra');

const DaoAccessControl = artifacts.require('./organization/DaoAccessControl');
// const DaoRecord = artifacts.require('./organization/DaoRecord');
// const DaoToken = artifacts.require('./organization/DaoToken');
const ProjectAccessControl = artifacts.require('./project-name1/ProjectAccessControl');
const ProjectRecord = artifacts.require('./project-name1/ProjectRecord');
const ProjectToken = artifacts.require('./project-name1/ProjectToken');
const ProjectProposal = artifacts.require('./project-name1/ProjectProposal');

let projectAccessControl;
let projectRecord;
let projectToken;

const projectTokenName = 'ProjectTokenNameForScript';
const projectTokenSymbol = 'PPP';
const projectAdminName = 'Yue';
const projectAdminEmail = 'yuyu5305@uni.sydney.edu.au';

module.exports = async function (deployer) {
  // Command Truffle to deploy the Smart Contract
  let daoAccessControl = await DaoAccessControl.deployed();
  await deployer.deploy(
    ProjectAccessControl,
    daoAccessControl.address,
    projectAdminName,
    projectAdminEmail
  );
  projectAccessControl = await ProjectAccessControl.deployed();
  daoAccessControl.grantAccountPermission("STAFF", projectAccessControl.address);

  await deployer.deploy(ProjectRecord, projectAccessControl.address);
  projectRecord = await ProjectRecord.deployed();

  await deployer.deploy(
    ProjectToken,
    projectAccessControl.address,
    projectTokenName,
    projectTokenSymbol
  );
  projectToken = await ProjectToken.deployed();
  
  projectAccessControl.grantAccountPermission("STAFF", projectRecord.address);
  projectAccessControl.grantAccountPermission("STAFF", projectToken.address);


  let outputInfo = {
    "ProjectAccessControl": {
      "address": projectAccessControl.address
    },
    "ProjectRecord": {
      "address": projectRecord.address
    },
    "ProjectToken": {
      "address": projectToken.address
    },
    "ProjectProposal": {
      // "address": daoProposal.address
    }
  };

  await fs.writeFile("./migrations/deployedProject.json", JSON.stringify(outputInfo, null, "\t"));


};
