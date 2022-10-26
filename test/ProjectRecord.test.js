const user = require('./accounts');
const ProjectRecord = artifacts.require('./project-name1/ProjectRecord');

contract('ProjectRecord', function () {

  it('Record project Objective', async function () {
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

  it('Record project Budget', async function () {
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

  it('Record project Schedule', async function () {
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

  it('Record project ROI Document', async function () {
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

  it('Record project Manament Plan Document', async function () {
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

  it('Record project Manament Risk plan document', async function () {
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

  // it('Record project Risk high', async function () {
  //   const projectRecord = await ProjectRecord.deployed();
  //   console.log('record risk level high to contract...');
  //   await projectRecord.recordRisk('high');
  //   const risk = await projectRecord.getRisk();
  //   console.log('Risk level: ', risk);
  //   assert.contain(risk, 'high', 'Record project Risk level Failed.');
  // });

  it('Record project NPV', async function () {
    const projectRecord = await ProjectRecord.deployed();
    console.log('record NPV 1000 to contract...');
    await projectRecord.recordNPV(1000);
    const NPV = await projectRecord.getNPV();
    console.log('NPV: ', NPV);
    assert.equal(NPV[0], 1000, 'Record project NPV Failed.');
  });
});
