const user = require('./accounts');
const DaoTestSender = artifacts.require('./organization/DaoTestSender');
// const DaoTestReceiver = artifacts.require('./organization/DaoTestReceiver');

contract('DaoTest', function () {
    it('should successfully sended money', async function () {
        let daoTestSender = await DaoTestSender.deployed();

        const info = await daoTestSender.inquiryInfo({ from: user.Minjia });
        console.log("before: ", info.toString());

        await daoTestSender.addTransferEthBehaviour(
            { from: user.Minjia, value: web3.utils.toWei("1.1", "ether") });
        
        const infoA = await daoTestSender.inquiryInfo({ from: user.Minjia });

        console.log("after: ", infoA.toString());
    });

});