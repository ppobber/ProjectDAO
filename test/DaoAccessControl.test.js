const user = require('./accounts');
const DaoAccessControl = artifacts.require('./organization/DaoAccessControl');

contract('DaoAccessControl', function () {

    it('Should successfully write admin name in constructor', async function () {
        const daoAccessControl = await DaoAccessControl.deployed();
        const daoAdminName = await daoAccessControl.inquiryDaoName({ from: user.Zoe });
        // assert.equal(daoAdminName, "Zoe", "Write into admin name failed.");
        expect(daoAdminName).to.equal("CS84");
        
    });

    it('Should equal with admin address and Zoe address', async function () {
        const daoAccessControl = await DaoAccessControl.deployed();
        const daoAdmin = await daoAccessControl.inquiryAdmin({ from: user.Zoe });
        expect(daoAdmin).to.equal(user.Zoe);
    });

    // it('Should not have permission to access by user who not in the organization', async function () {
    //     const daoAccessControl = await DaoAccessControl.deployed();
    //     // let error = null;
    //     // try {
    //     //     const daoAdmin = await daoAccessControl.inquiryAdmin({ from: user.Home });
    //     // } catch (catchError) {
    //     //     error = catchError;
    //     // } finally {
    //     //     if (error) {
    //     //         expect(true).to.be.true;
    //     //     } else {
    //     //         expect(function () { throw new TypeError('Aceess Control Failed.')}).throw();
    //     //     }
    //     // }
    //     const hasPermission = daoAccessControl.inquiryAccountPermission("STAFF", user.Home, { from: user.Zoe });
    //     expert(hasPermission).to.be.false;
    //     expect(function () {
    //         daoAccessControl.inquiryAdmin({ from: user.Home });
    //     }).to.thorw();

    // });

    // it('Should successfully grant permission STAFF to user', async function () {
    //     const daoAccessControl = await DaoAccessControl.deployed();
    //     await daoAccessControl.grantAccountPermission("STAFF", user.Home, { from: user.Zoe });
    //     // await daoAccessControl.inquiryAdmin({ from: user.Home });
    //     const hasPermission = daoAccessControl.inquiryAccountPermission("STAFF", user.Home, { from: user.Zoe });
    //     expert(hasPermission).to.be.true;
    //     expect(function () {
    //         daoAccessControl.inquiryAdmin({ from: user.Home });
    //     }).to.not.thorw();
        
    // });

    // it('Should successfully grant permissions to users', async function () {
    //     const daoAccessControl = await DaoAccessControl.deployed();
    //     daoAccessControl.grantAccountPermission("ACCESS_MANAGER", user.Yue, { from: user.Zoe });
    //     daoAccessControl.grantAccountPermission("TOKEN_MANAGER", user.Home, { from: user.Zoe });
    //     daoAccessControl.grantAccountPermission("PROPOSAL_MANAGER", user.Mengjia, { from: user.Zoe });
    //     daoAccessControl.grantAccountPermission("RECORD_MANAGER", user.Juncheng, { from: user.Zoe });
    //     daoAccessControl.grantAccountPermission("STAFF", user.Yue, { from: user.Yue });
    //     daoAccessControl.grantAccountPermission("STAFF", user.Home, { from: user.Yue });
    //     daoAccessControl.grantAccountPermission("STAFF", user.Mengjia, { from: user.Yue });
    //     daoAccessControl.grantAccountPermission("STAFF", user.Juncheng, { from: user.Yue });
    //     daoAccessControl.grantAccountPermission("MEMBER", user.Yue, { from: user.Yue });
    //     daoAccessControl.grantAccountPermission("MEMBER", user.Home, { from: user.Yue });
    //     daoAccessControl.grantAccountPermission("MEMBER", user.Mengjia, { from: user.Yue });
    //     daoAccessControl.grantAccountPermission("MEMBER", user.Juncheng, { from: user.Yue });
    //     const allPermissions = daoAccessControl.inquiryAllPermissionsByAccount(user.Yue, { from: user.Yue });
    //     expect(allPermissions).to.deep.include(["ACCESS_MANAGER", "STAFF", "MEMBER"]);
    //     const allAccounts = daoAccessControl.inquiryAllAccountsByPermission("STAFF", { from: user.Yue });
    //     expect(allAccounts).to.deep.include([user.Zoe, user.Yue, user.Home, user.Mengjia, user.Juncheng]);

    // });

    




    // it('Should granted STAFF permission to DaoRecord contract', async function () {

    // });

    // it('Should successfully get admin address', async function () {
    //     const daoAccessControl = await DaoAccessControl.deployed();
    //     const daoAdmin = await daoAccessControl.inquiryAdmin({ from: user_Zoe });
    //     // assert.equal(daoAdminName, "Zoe", "Write into admin name failed.");
    //     expect(daoAdminName).to.equal("Zoe");
        
    // });
    
    
    
});
