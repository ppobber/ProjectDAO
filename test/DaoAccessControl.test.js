const DaoAccessControl = artifacts.require('./organization/DaoAccessControl');

contract('DaoAccessControl', function (accounts) {

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

    it('Should successfully write admin name in constructor', async function () {
        const daoAccessControl = await DaoAccessControl.deployed();
        const daoAdminName = await daoAccessControl.inquiryDaoName({ from: user_Zoe });
        // assert.equal(daoAdminName, "Zoe", "Write into admin name failed.");
        expect(daoAdminName).to.equal("CS84");
        
    });

    it('Should successfully get admin address', async function () {
        const daoAccessControl = await DaoAccessControl.deployed();
        const daoAdmin = await daoAccessControl.inquiryAdmin({ from: user_Zoe });
        // assert.equal(daoAdminName, "Zoe", "Write into admin name failed.");
        expect(daoAdminName).to.equal("Zoe");
        
    });
    
    
    
});
