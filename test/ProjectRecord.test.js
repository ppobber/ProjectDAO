const { copySync } = require('fs-extra');

const ProjectRecord = artifacts.require('./project-name1/ProjectRecord');
contract('ProjectRecord', function (accounts) {
  const user_Zoe = accounts[0];
  const user_Yue = accounts[1];
  const user_Home = accounts[2];
  const user_Mengjia = accounts[3];
  const user_Juncheng = accounts[4];
  const user_Minjia = accounts[5];
  const user_Diao = accounts[6];
  const user_Yichen = accounts[7];
  const user_Weijia = accounts[8];
  const user_Hexin = accounts[9];

  it('Record project Objective', async () => {
    const projectRecord = await ProjectRecord.deployed();
    console.log('record file projectObj.json to contract...');
    await projectRecord.setProjectObjective('projectObj.json');
    const projectObj = await projectRecord.getProjectObjective();
    console.log('projectObj: ', projectObj);
    assert.equal(
      projectObj,
      'projectObj.json',
      'Record project Objectivefailed.'
    );
  });

  it('Record project Budget', async () => {
    const projectRecord = await ProjectRecord.deployed();
    console.log('record file projectBudget.json to contract...');
    await projectRecord.setProjectBudget('projectBudget.json');
    const projectBudget = await projectRecord.getProjectBudget();
    console.log('projectBudget: ', projectBudget);
    assert.equal(
      projectBudget,
      'projectBudget.json',
      'Record project OprojectObj Failed.'
    );
  });

  it('Record project Schedule', async () => {
    const projectRecord = await ProjectRecord.deployed();
    console.log('record file projectSchedule.json to contract...');
    await projectRecord.setProjectSchedule('projectSchedule.json');
    const projectSchedule = await projectRecord.getProjectSchedule();
    console.log('ProjectSchedule Doc: ', projectSchedule);
    assert.equal(
      projectSchedule,
      'projectSchedule.json',
      'Record project projectSchedule Failed.'
    );
  });

  it('Record project ROI Document', async () => {
    const projectRecord = await ProjectRecord.deployed();
    console.log('record file ProjectROI.json to contract...');
    await projectRecord.setProjectROI('projectROI.json');
    const projectROI = await projectRecord.getProjectROI();
    console.log('projectROI DOC: ', projectROI);
    assert.equal(
      projectROI,
      'projectROI.json',
      'Record project projectROI Failed.'
    );
  });

  it('Record project Manament Plan Document', async () => {
    const projectRecord = await ProjectRecord.deployed();
    console.log('record file projectMgmtPlan.json to contract...');
    await projectRecord.setProjectMgmtPlan('ProjectMgmtPlan.json');
    const projectMgmtPlan = await projectRecord.getProjectMgmtPlan();
    console.log('ProjectMgmtPlan DOC: ', projectMgmtPlan);
    assert.equal(
      projectMgmtPlan,
      'ProjectMgmtPlan.json',
      'Record project ProjectMgmtPlan Failed.'
    );
  });

  it('Record project Manament Risk plan document', async () => {
    const projectRecord = await ProjectRecord.deployed();
    console.log('record file ProjectRiskPlan.json to contract...');
    await projectRecord.setProjectRiskPlan('ProjectRiskPlan.json');
    const projectRiskPlan = await projectRecord.getProjectRiskPlan();
    console.log('ProjectRiskPlan Doc: ', projectRiskPlan);
    assert.equal(
      projectRiskPlan,
      'ProjectRiskPlan.json',
      'Record project ProjectRiskPlan Failed.'
    );
  });

  it('Record project Risk high', async () => {
    const projectRecord = await ProjectRecord.deployed();
    console.log('record risk level high to contract...');
    await projectRecord.recordRisk('high');
    const risk = await projectRecord.getRisk();
    const hash_high = 0x078337cd7e888008d653d6c34a2d35f15deaf16a2b59266222cab4f560af370f;
    console.log('Risk level: ', risk);
    assert.equal(risk, hash_high, 'Record project Risk level Failed.');
  });

  it('Record project NPV', async () => {
    const projectRecord = await ProjectRecord.deployed();
    console.log('record NPV 1000 to contract...');
    await projectRecord.recordNPV(1000);
    const NPV = await projectRecord.getNPV();
    console.log('NPV: ', NPV[0]);
    assert.equal(NPV[0], 1000, 'Record project NPV Failed.');
  });
});
