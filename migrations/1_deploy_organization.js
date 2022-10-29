const fs = require('fs-extra');

const DaoAccessControl = artifacts.require('./organization/DaoAccessControl');
const DaoRecord = artifacts.require('./organization/DaoRecord');
const DaoToken = artifacts.require('./organization/DaoToken');
const DaoProposal = artifacts.require('./organization/DaoProposal');
const DaoProposalRecord = artifacts.require('./organization/DaoProposalRecord');
const StringUtils = artifacts.require('./StringUtils.sol');

let daoAccessControl;
let daoRecord;
let daoToken;
let daoProposal;
let daoProposalRecord;

const daoName = "CS84";
const daoTokenName = "DAO Token Name";
const daoTokenSymbol = "DDD";

const daoProposalContractName = "DAO Proposal Contract";
// const quorumNumeratorValue = 0;
// const initialVoteExtension = 0;
const initialVotingDelay = 0;
const initialVotingPeriod = 10;
const initialProposalThreshold = 0;
const initialquorumNumber = 0;


module.exports = async function (deployer, network, accounts) {

  fromAdmin = { from: accounts[0] };

  await deployer.deploy(DaoAccessControl, daoName, fromAdmin);
  daoAccessControl = await DaoAccessControl.deployed();

  await deployer.deploy(DaoRecord, daoAccessControl.address, fromAdmin);
  daoRecord = await DaoRecord.deployed();

  await deployer.deploy(
    DaoToken,
    daoAccessControl.address,
    daoTokenName,
    daoTokenSymbol,
    fromAdmin
  );
  daoToken = await DaoToken.deployed();

  await deployer.deploy(
    DaoProposal,
    daoAccessControl.address,
    daoProposalContractName,
    daoToken.address,
    initialVotingDelay,
    initialVotingPeriod,
    initialProposalThreshold,
    initialquorumNumber,
    fromAdmin
  );
  daoProposal = await DaoProposal.deployed();

  await deployer.deploy(StringUtils, fromAdmin);
  await deployer.link(StringUtils, DaoProposalRecord, fromAdmin);
  await deployer.deploy(
    DaoProposalRecord,
    daoAccessControl.address,
    daoProposal.address,
    daoRecord.address,
    daoToken.address,
    fromAdmin
  );
  daoProposalRecord = await DaoProposalRecord.deployed();

  await daoAccessControl.grantAccountPermission("STAFF", daoRecord.address, fromAdmin);
  await daoAccessControl.grantAccountPermission("STAFF", daoToken.address, fromAdmin);
  await daoAccessControl.grantAccountPermission("STAFF", daoProposal.address, fromAdmin);
  await daoAccessControl.grantAccountPermission("STAFF", daoProposalRecord.address, fromAdmin);

  await daoAccessControl.grantAccountPermission("ACCESS_MANAGER", daoProposal.address, fromAdmin);
  await daoAccessControl.grantAccountPermission("TOKEN_MANAGER", daoProposal.address, fromAdmin);
  await daoAccessControl.grantAccountPermission("RECORD_MANAGER", daoProposal.address, fromAdmin);
  await daoAccessControl.grantAccountPermission("PROPOSAL_MANAGER", daoProposal.address, fromAdmin);

  await daoAccessControl.grantAccountPermission("PROPOSAL_MANAGER", daoProposalRecord.address, fromAdmin);

  let outputInfo = {
    "DaoAccessControl": {
      "address": daoAccessControl.address
    },
    "DaoRecord": {
      "address": daoRecord.address
    },
    "DaoToken": {
      "address": daoToken.address
    },
    "DaoProposal": {
      "address": daoProposal.address
    }
  };

  // console.log(outputInfo);
  await fs.writeFile("./migrations/deployedOrganization.json", JSON.stringify(outputInfo, null, "\t"));

};
