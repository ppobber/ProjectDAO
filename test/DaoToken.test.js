const DaoToken = artifacts.require('./organization/DaoToken');
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

  it('Should record and and query successfully', async () => {
    //const daoAccessControl = await DaoAccessControl.deployed();
    const daoToken = await DaoToken.deployed();
    const decimals = await daoToken.decimals();
    const name = await daoToken.name();

    console.log('mint 100 token');
    daoToken.mint(accounts[0], 100);
    const totalSupply = await daoToken.totalSupply();
    console.log('decimals: ', decimals);
    console.log('name: ', name);
    console.log('total Supply: ', totalSupply);
    assert.equal(decimals, 18, 'Write into admin name failed.');

    //expect(totalSupply).to.equal(12);
  });
});
