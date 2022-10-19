const ProjectAccessControl = artifacts.require(
  './project-name1/ProjectAccessControl'
);
//const database = artifacts.require('./database.js');

contract('ProjectAccessControl', (accounts) => {
  it('Show admin name and email', async () => {
    const Instance = await ProjectAccessControl.deployed();
    const info = await Instance.inquiryAdminInformation();
    console.log('Admin Name: ', info);
    assert.equal(info[0], 'Zoe', 'Test fail');
    assert.equal(info[1], 'Zoe@email.com', 'Test fail');
  });

  it('Show admin address', async () => {
    const Instance = await ProjectAccessControl.deployed();
    const info = await Instance.inquiryAdmin();
    console.log('Admin account: ', info);
    assert.equal(
      info,
      '0xD43FB248AEceA941c7e37AE29eFcEd0C18D7051d',
      'Test fail'
    );
  });
});
