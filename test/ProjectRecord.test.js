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
});
