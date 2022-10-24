const { copySync } = require('fs-extra');

const DaoRecord = artifacts.require('./organization/DaoRecord');
contract('DaoToken', function (accounts) {
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
  // const user_Zhumin = accounts[10];

  it('Record message "test" to contract', async () => {
    //const daoAccessControl = await DaoAccessControl.deployed();
    const daoRecord = await DaoRecord.deployed();
    console.log('record test to contract...');
    await daoRecord.recordInformation('test');
    const info = await daoRecord.inquiryInformation();

    console.log('record: ', info);
    assert.equal(info[0], 'test', 'record failed.');
  });
});
