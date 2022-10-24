const user = require('./accounts');
const DaoAccessControl = artifacts.require('./organization/DaoAccessControl');

contract('DaoAccessControl', function () {

    it('Should successfully write admin name in constructor', async function () {
        const daoAccessControl = await DaoAccessControl.deployed();
        const daoAdminName = await daoAccessControl.inquiryDaoName({ from: user.Zoe });
        // assert.equal(daoAdminName, "Zoe", "Write into admin name failed.");
        expect(daoAdminName).to.equal("CS84");
        
    });

    it('Should equal with admin address and Zoe address ', async function () {
        const daoAccessControl = await DaoAccessControl.deployed();
        const daoAdminName = await daoAccessControl.inquiryAdmin({ from: user.Zoe });
        // assert.equal(daoAdminName, "Zoe", "Write into admin name failed.");
        expect(daoAdminName).to.equal("CS84");
        
    });

    it('Should granted STAFF permission to DaoRecord contract', async function () {

    });

    // it('Should successfully get admin address', async function () {
    //     const daoAccessControl = await DaoAccessControl.deployed();
    //     const daoAdmin = await daoAccessControl.inquiryAdmin({ from: user_Zoe });
    //     // assert.equal(daoAdminName, "Zoe", "Write into admin name failed.");
    //     expect(daoAdminName).to.equal("Zoe");
        
    // });
    
    
    
});
