const DaoAccessControl = artifacts.require('./organization/DaoAccessControl');
//const database = artifacts.require('./database.js');

contract('DaoAccessControl', (accounts) => {
  it('Show admin account', async () => {
    const Instance = await DaoAccessControl.deployed();
    const info = await Instance.inquiryAdmin();
    console.log('Admin Account: ', info, 'Account[0]: ', accounts[0]);
    
    assert.equal(
      info,
      '0xD43FB248AEceA941c7e37AE29eFcEd0C18D7051d',
      'Test fail'
    );
  });
});
