/*
Create an Oganization
*/

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

//todo
const domainSeparator = "aaa";
const quorumNumeratorValue = 0;
const initialVoteExtension = 0;
const initialVotingDelay = 1293143;
const initialVotingPeriod = 5891431;
const initialProposalThreshold = 0;


module.exports = async function (deployer) {
  // Command Truffle to deploy the Smart Contract

  await deployer.deploy(DaoAccessControl, daoName);
  daoAccessControl = await DaoAccessControl.deployed();

  await deployer.deploy(DaoRecord, daoAccessControl.address);
  daoRecord = await DaoRecord.deployed();

  await deployer.deploy(
    DaoToken,
    daoAccessControl.address,
    daoTokenName,
    daoTokenSymbol
  );
  daoToken = await DaoToken.deployed();

  // await deployer.deploy(
  //   DaoProposal,
  //   daoAccessControl.address,
  //   domainSeparator,
  //   daoToken.address,
  //   quorumNumeratorValue,
  //   initialVoteExtension,
  //   initialVotingDelay,
  //   initialVotingPeriod,
  //   initialProposalThreshold
  // )
  // daoProposal = await DaoProposal.deployed();

  daoAccessControl.grantAccountPermission("STAFF", daoRecord.address);
  daoAccessControl.grantAccountPermission("STAFF", daoToken.address);
  // daoAccessControl.grantAccountPermission("STAFF", daoProposal.address);

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
      // "address": daoProposal.address
    }
  };

  // console.log(outputInfo);
  await fs.writeFile("./migrations/deployedOrganization.json", JSON.stringify(outputInfo, null, "\t"));

};
