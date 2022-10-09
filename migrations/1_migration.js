// Help Truffle find `TruffleTutorial.sol` in the `/contracts` directory

const OrgAcc = artifacts.require('/organization/DaoAccessControl');
const OrgRecord = artifacts.require('/organization/DaoAccessControl');
const ProAcc = artifacts.require('/project-name1/ProjectAccessControl');
const ProRecord = artifacts.require('/project-name1/ProjectRecord');

module.exports = async function (deployer) {
  // Command Truffle to deploy the Smart Contract
  await deployer.deploy(OrgAcc);
  await deployer.deploy(OrgRecord);
  const token = await OrgToken.deployed();
  await deployer.deploy(MyOrg, OrgToken.address);
  const org = MyOrg.deployed();
  await deployer.deploy(Admin);
};
