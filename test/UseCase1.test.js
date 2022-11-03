// Zoe create the organization call MyCOM and create Token name MyCOMTOKEN (MCT)

/*
Create an Oganization
*/

//const user = require('./accounts');
const fs = require('fs-extra');
const DaoAccessControl = artifacts.require('./organization/DaoAccessControl');
const DaoRecord = artifacts.require('./organization/DaoRecord');
const DaoToken = artifacts.require('./organization/DaoToken');
const DaoProposal = artifacts.require('./organization/DaoProposal');
const ProjectAccessControl = artifacts.require(
  './project/ProjectAccessControl'
);
const ProjectRecord = artifacts.require('./project/ProjectRecord');
const ProjectToken = artifacts.require('./project/ProjectToken');
const ProjectProposal = artifacts.require('./project/ProjectProposal');

module.exports = async function (callback) {
  // Zoe create the organization call MyCOM and create Token name MyCOMTOKEN (MCT)
  const [
    Zoe,
    Yue,
    Home,
    Mengjia,
    Juncheng,
    voter6,
    voter7,
    voter8,
    voter9,
    voter10,
  ] = await web3.eth.getAccounts();
  const daoAccessControl = await DaoAccessControl.deployed();
  const daoRecord = await DaoRecord.deployed();
  const daoToken = await DaoToken.deployed();
  const companyName = await daoAccessControl.inquiryDaoName();
  const companyTokenName = await daoToken.name();
  const companyTokenSymbol = await daoToken.symbol();
  const projectAccessControl = await ProjectAccessControl.deployed();
  const projectRecord = await ProjectRecord.deployed();
  const projectToken = await ProjectToken.deployed();

  function sleep(ms) {
    return new Promise((resolve) => setTimeout(resolve, ms));
  }

  console.log('====  Print Company information ====');
  console.log('Organization Name: ', companyName);
  console.log('Token Name: ', companyTokenName);
  console.log('Token Symbol: ', companyTokenSymbol);
  console.log('====================================');

  // Zoe create a organization internal message to introduce the company

  await daoRecord.recordInformation(
    'This is Zoe anybody who has an idea of a project can contact me'
  );
  const internalmsg = await daoRecord.inquiryInformation();
  console.log("====  Zoe's message  ====");
  console.log('Massgae to Company Members: ', internalmsg[0]);

  // Yue add a new message to add more deteils about the company but faile because he dosen't have the right
  console.log(
    "====  Yue tries to add new record but the system doesn't allow  ===="
  );
  try {
    await daoRecord.recordInformation('This is Yue I am the record manager', {
      from: Yue,
    });
  } catch (e) {
    console.log('...Permission denied...');
  }

  console.log('====  Zoe grant a Record manager permision to Yue  ====');
  // Zoe grant the role of RECORD_MANAGER to yue.
  await daoAccessControl.grantAccountPermission('STAFF', Yue, {
    from: Zoe,
  });

  await daoAccessControl.grantAccountPermission('RECORD_MANAGER', Yue, {
    from: Zoe,
  });
  await sleep(6000);

  // Now Yue can add the massge to the company records.
  await daoRecord.recordInformation('This is Yue I am the record manager', {
    from: Yue,
  });
  console.log("====  Yue's message  ====");
  console.log('Massgae to Company Members: ', internalmsg[0]);
  console.log('Massgae to Company Members: ', internalmsg[1]);

  // Zoe want to add Home in as a person who haddle Token
  console.log('====  Zoe grant a Token manager permision to home  ====');
  await daoAccessControl.grantAccountPermission('STAFF', Home, {
    from: Zoe,
  });
  await daoAccessControl.grantAccountPermission('TOKEN_MANAGER', Home, {
    from: Zoe,
  });
  await sleep(6000);
  // const tokenManagerPermission = 'TOKEN_MANAGER';
  // const tokenMgmt = await daoAccessControl.inquiryAccountPermission(
  //   tokenManagerPermission,
  //   Home,
  //   { from: Zoe }
  // );
  const totalSupply = await daoToken.totalSupply();
  //console.log('TokenMgmt: ', tokenMgmt);
  console.log('Total supply: ', totalSupply.toNumber());

  // Home create 100 Token and assign it to Zoe

  console.log('====  Home mint 100 Token to Zoe  ====');
  await daoToken.mint(Zoe, 100, { from: Home });
  console.log('Total supply: ', totalSupply.toNumber());
  var zoeBalance = await daoToken.balanceOf(Zoe);
  console.log('Zoe balance: ', zoeBalance.toNumber());
  console.log('======================================');

  // Zoe what to tranfer 25 token to home and 25 token to Yue
  console.log('====  Zoe tranfer 25 token to home and 25 token to Yue  ====');
  var yueBalance = await daoToken.balanceOf(Yue);
  var homeBalance = await daoToken.balanceOf(Home);
  await daoToken.transfer(Zoe, Yue, 25);
  await daoToken.transfer(Zoe, Home, 25);
  console.log('Zoe balance: ', zoeBalance.toNumber());
  console.log('Yue balance: ', yueBalance.toNumber());
  console.log('Home balance: ', homeBalance.toNumber());
  console.log('============================================================');

  // Zoe have a project idea and assign Mengjia to be the project manager
  await projectAccessControl.grantAccountPermission('ACCESS_MANAGER', Mengjia);
  await projectAccessControl.grantAccountPermission('STAFF', Mengjia);
  await projectAccessControl.grantAccountPermission('RECORD_MANAGER', Mengjia);

  // Mengjia creats documentations for the project
  console.log('===== record file projectObj.json to contract =====');
  await projectRecord.setProjectObjective('projectObj.json', { from: Mengjia });
  const projectObj = await projectRecord.getProjectObjective();
  console.log('projectObj: ', projectObj);
  console.log('===== record file projectBudget.json to contract =====');
  await projectRecord.setProjectBudget('projectBudget.json');
  const projectBudget = await projectRecord.getProjectBudget();
  console.log('projectBudget: ', projectBudget);
  console.log('===== record file projectSchedule.json to contract =====');
  await projectRecord.setProjectSchedule('projectSchedule.json');
  const projectSchedule = await projectRecord.getProjectSchedule();
  console.log('ProjectSchedule Doc: ', projectSchedule);
  console.log('===== record file ProjectROI.json to contract =====');
  await projectRecord.setProjectROI('projectROI.json');
  const projectROI = await projectRecord.getProjectROI();
  console.log('projectROI DOC: ', projectROI);
  console.log('===== record file projectMgmtPlan.json to contract =====');
  await projectRecord.setProjectMgmtPlan('ProjectMgmtPlan.json');
  const projectMgmtPlan = await projectRecord.getProjectMgmtPlan();
  console.log('ProjectMgmtPlan DOC: ', projectMgmtPlan);
  console.log('===== record file ProjectRiskPlan.json to contract =====');
  await projectRecord.setProjectRiskPlan('ProjectRiskPlan.json');
  const projectRiskPlan = await projectRecord.getProjectRiskPlan();
  console.log('ProjectRiskPlan Doc: ', projectRiskPlan);
  console.log('===== record risk level high to contract =====');
  await projectRecord.recordRisk('high');
  const risk = await projectRecord.getRisk();
  console.log('Risk level: ', risk[0]);
  console.log('===== record NPV 1000 to contract =====');
  await projectRecord.recordNPV(1000);
  const NPV = await projectRecord.getNPV();
  console.log('NPV: ', NPV[0].toNumber());

  // Mengjia is very busy so she hire Jushung to help her doing the presentation
  await projectAccessControl.grantAccountPermission('STAFF', Juncheng, {
    from: Mengjia,
  });

  // As this point Juncheng can access the project documatations but not a record in the company and can not make change to the project Doc
  const projectMgmtPlan_Juncheng = await projectRecord.getProjectMgmtPlan({
    from: Juncheng,
  });
  console.log(
    'ProjectRiskPlan Doc query by Juncheng: ',
    projectMgmtPlan_Juncheng
  );
  callback();
};

// As this point Jushung can assess the project documatations but not a record in the company and can not make change to the project Doc
