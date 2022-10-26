const fs = require('fs-extra');

const DaoAccessControl = artifacts.require('./organization/DaoAccessControl');
const DaoRecord = artifacts.require('./organization/DaoRecord');
const DaoToken = artifacts.require('./organization/DaoToken');
const DaoProposal = artifacts.require('./organization/DaoProposal');

let daoAccessControl;
let daoRecord;
let daoToken;
let daoProposal;

const daoName = "CS84";
const daoTokenName = "DaoTokenNameForScript";
const daoTokenSymbol = "DDD";

const domainSeparator = "aaa";
// const quorumNumeratorValue = 0;
// const initialVoteExtension = 0;
const initialVotingDelay = 1293143;
const initialVotingPeriod = 5891431;
const initialProposalThreshold = 0;


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
    domainSeparator,
    daoToken.address,
    initialVotingDelay,
    initialVotingPeriod,
    initialProposalThreshold,
    fromAdmin
  );
  daoProposal = await DaoProposal.deployed();

  await daoAccessControl.grantAccountPermission("STAFF", daoRecord.address, fromAdmin);
  await daoAccessControl.grantAccountPermission("STAFF", daoToken.address, fromAdmin);
  await daoAccessControl.grantAccountPermission("STAFF", daoProposal.address, fromAdmin);

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
