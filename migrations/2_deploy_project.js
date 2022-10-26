const fs = require('fs-extra');

const DaoAccessControl = artifacts.require('./organization/DaoAccessControl');
const ProjectAccessControl = artifacts.require('./project-name1/ProjectAccessControl');
const ProjectRecord = artifacts.require('./project-name1/ProjectRecord');
const ProjectToken = artifacts.require('./project-name1/ProjectToken');
const ProjectProposal = artifacts.require('./project-name1/ProjectProposal');

let projectAccessControl;
let projectRecord;
let projectToken;
let projectProposal;

const projectName = "ProjectNameForTest";
const projectTokenName = 'ProjectTokenNameForTest';
const projectTokenSymbol = 'PPP';
const projectAdminName = 'Yue';
const projectAdminEmail = 'yuyu5305@uni.sydney.edu.au';

const domainSeparator = "bbb";
const initialVotingDelay = 1293143;
const initialVotingPeriod = 5891431;
const initialProposalThreshold = 0;

module.exports = async function (deployer) {

  let daoAccessControl = await DaoAccessControl.deployed();
  await deployer.deploy(
    ProjectAccessControl,
    daoAccessControl.address,
    projectName,
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

  await deployer.deploy(
    ProjectProposal,
    projectAccessControl.address,
    domainSeparator,
    projectToken.address,
    initialVotingDelay,
    initialVotingPeriod,
    initialProposalThreshold
  );
  projectProposal = await ProjectProposal.deployed();
  
  projectAccessControl.grantAccountPermission("STAFF", projectRecord.address);
  projectAccessControl.grantAccountPermission("STAFF", projectToken.address);
  projectAccessControl.grantAccountPermission("STAFF", projectProposal.address);

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
      "address": projectProposal.address
    }
  };

  await fs.writeFile("./migrations/deployedProject.json", JSON.stringify(outputInfo, null, "\t"));


};
