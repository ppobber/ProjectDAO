// const { copySync } = require('fs-extra');
const DaoRecord = artifacts.require('./organization/DaoRecord');

contract('DaoToken', function () {
  it('Record message "test" to contract', async function () {
    //const daoAccessControl = await DaoAccessControl.deployed();
    const daoRecord = await DaoRecord.deployed();
    console.log('record test to contract...');
    await daoRecord.recordInformation('test');
    const info = await daoRecord.inquiryInformation();

    console.log('record: ', info);
    assert.equal(info[0], 'test', 'record failed.');
  });
});
