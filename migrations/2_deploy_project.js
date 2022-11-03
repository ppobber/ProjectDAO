const fs = require('fs-extra');

const DaoAccessControl = artifacts.require('./organization/DaoAccessControl');
const ProjectAccessControl = artifacts.require('./project/ProjectAccessControl');
const ProjectRecord = artifacts.require('./project/ProjectRecord');
const ProjectToken = artifacts.require('./project/ProjectToken');
const ProjectProposal = artifacts.require('./project/ProjectProposal');
const ProjectProposalRecord = artifacts.require('./project/ProjectProposalRecord');

const StringUtils = artifacts.require('./StringUtils.sol');

let projectAccessControl;
let projectRecord;
let projectToken;
let projectProposal;
let projectProposalRecord;

const projectName = "Project Name";
const projectTokenName = 'Project Token Name';
const projectTokenSymbol = 'PPP';
const projectAdminName = 'Yue';
const projectAdminEmail = 'yuyu5305@uni.sydney.edu.au';

const projectProposalContractName = "Project Proposal Contract";
const initialVotingDelay = 0;
const initialVotingPeriod = 8;
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

  await deployer.link(StringUtils, ProjectProposalRecord, fromAdmin);
  await deployer.deploy(
    ProjectProposalRecord,
    projectAccessControl.address,
    projectProposal.address,
    projectRecord.address,
    projectToken.address,
    fromAdmin
  );
  projectProposalRecord = await ProjectProposalRecord.deployed();
  
  await projectAccessControl.grantAccountPermission("STAFF", projectRecord.address, fromAdmin);
  await projectAccessControl.grantAccountPermission("STAFF", projectToken.address, fromAdmin);
  await projectAccessControl.grantAccountPermission("STAFF", projectProposal.address, fromAdmin);
  await projectAccessControl.grantAccountPermission("STAFF", projectProposalRecord.address, fromAdmin);

  await projectAccessControl.grantAccountPermission("ACCESS_MANAGER", projectProposal.address, fromAdmin);
  await projectAccessControl.grantAccountPermission("TOKEN_MANAGER", projectProposal.address, fromAdmin);
  await projectAccessControl.grantAccountPermission("RECORD_MANAGER", projectProposal.address, fromAdmin);
  await projectAccessControl.grantAccountPermission("PROPOSAL_MANAGER", projectProposal.address, fromAdmin);

  await projectAccessControl.grantAccountPermission("PROPOSAL_MANAGER", projectProposalRecord.address, fromAdmin);

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
