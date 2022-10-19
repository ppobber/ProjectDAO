// // Help Truffle find `TruffleTutorial.sol` in the `/contracts` directory

// const DaoAcc = artifacts.require('./organization/DaoAccessControl');
// const DaoRecord = artifacts.require('./organization/DaoRecord');
// //const DaoToken = artifacts.require('./organization/DaoToken');
// const ProAcc = artifacts.require('./project-name1/ProjectAccessControl');
// const ProRecord = artifacts.require('./project-name1/ProjectRecord');
// // const ProToken = artifacts.require('./project-name1/ProjectToken');

// module.exports = async function (deployer) {
//   // Command Truffle to deploy the Smart Contract
//   await deployer.deploy(DaoAcc);
//   await deployer.deploy(DaoRecord, DaoAcc.address);
//   //await deployer.deploy(DaoToken, DaoAcc.address);
//   //const token = await OrgToken.deployed();
//   //await deployer.deploy(MyOrg, OrgToken.address);
//   //const org = MyOrg.deployed();
//   await deployer.deploy(ProAcc, DaoAcc.address, 'Zoe', 'Zoe@email');
//   await deployer.deploy(ProRecord, ProAcc.address);
//   // await deployer.deploy(ProToken, ProAcc, PROJECTTOKEN, PTK);
// };

var daoAccessControl;
var daoRecord;
var daoToken;
var projectAccessControl;
var projectRecord;
var projectToken;

exports.daoAccessControl = daoAccessControl;
exports.daoRecord = daoRecord;
exports.daoToken = daoToken;
exports.projectToken = projectToken;
exports.projectAccessControl = projectAccessControl;
exports.projectRecord = projectRecord;
