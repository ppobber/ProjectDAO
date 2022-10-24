const user = require('./accounts');
const DaoRecord = artifacts.require('./organization/DaoRecord');

contract('DaoRecord', function () {

    it('Should successfully inquiry', async function () {
        const daoRecord = await DaoRecord.deployed();
        const testString = await daoRecord.inquiryTest({ from: user.Zoe });
        // assert.equal(daoAdminName, "Zoe", "Write into admin name failed.");
        console.log(testString);
        expect(testString).to.equal("Call Success");
        
    });

    // it('Should successfully get admin address', async function () {
    //     const daoAccessControl = await DaoAccessControl.deployed();
    //     const daoAdmin = await daoAccessControl.inquiryAdmin({ from: user_Zoe });
    //     // assert.equal(daoAdminName, "Zoe", "Write into admin name failed.");
    //     expect(daoAdminName).to.equal("Zoe");
        
    // });
    
    
    
});