const DaoRecord = artifacts.require('./organization/DaoRecord');

contract('DaoRecord', function (accounts) {
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

  it('Should record and and query successfully', async () => {
    //const daoAccessControl = await DaoAccessControl.deployed();
    const daoRecord = await DaoRecord.deployed();
    const recordInfo = 'This is the message in Dao Record';
    daoRecord.recordInformation(recordInfo);
    const daoInfo = await daoRecord.inquiryInformation();
    // assert.equal(daoAdminName, "Zoe", "Write into admin name failed.");
    console.log(daoInfo[0]);
    expect(daoInfo[0]).to.equal('This is the message in Dao Record');
  });
});
