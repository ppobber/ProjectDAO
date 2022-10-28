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

const projectName = "Project Name";
const projectTokenName = 'Project Token Name';
const projectTokenSymbol = 'PPP';
const projectAdminName = 'Yue';
const projectAdminEmail = 'yuyu5305@uni.sydney.edu.au';

const projectProposalContractName = "Project Proposal Contract";
const initialVotingDelay = 0;
const initialVotingPeriod = 10;
const initialProposalThreshold = 0;
const initialquorumNumber = 0;

module.exports = async function (deployer, network, accounts) {

  fromAdmin = { from: accounts[0] };

  let daoAccessControl = await DaoAccessControl.deployed();
  await deployer.deploy(
    ProjectAccessControl,
    daoAccessControl.address,
    projectName,
    projectAdminName,
    projectAdminEmail,
    fromAdmin);
  projectAccessControl = await ProjectAccessControl.deployed();
  await daoAccessControl.grantAccountPermission("STAFF", projectAccessControl.address, fromAdmin);

  await deployer.deploy(
    ProjectRecord,
    projectAccessControl.address,
    fromAdmin);
  projectRecord = await ProjectRecord.deployed();

  await deployer.deploy(
    ProjectToken,
    projectAccessControl.address,
    projectTokenName,
    projectTokenSymbol,
    fromAdmin
  );
  projectToken = await ProjectToken.deployed();

  await deployer.deploy(
    ProjectProposal,
    projectAccessControl.address,
    projectProposalContractName,
    projectToken.address,
    initialVotingDelay,
    initialVotingPeriod,
    initialProposalThreshold,
    initialquorumNumber,
    fromAdmin
  );
  projectProposal = await ProjectProposal.deployed();
  
  await projectAccessControl.grantAccountPermission("STAFF", projectRecord.address, fromAdmin);
  await projectAccessControl.grantAccountPermission("STAFF", projectToken.address, fromAdmin);
  await projectAccessControl.grantAccountPermission("STAFF", projectProposal.address, fromAdmin);

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
