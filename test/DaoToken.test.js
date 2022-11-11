const user = require('./accounts');
const DaoToken = artifacts.require('./organization/DaoToken');

contract('DaoToken', function () {

  it('Check name and tokens symbol', async function () {
    //const daoAccessControl = await DaoAccessControl.deployed();
    const daoToken = await DaoToken.deployed();
    const decimals = await daoToken.decimals();
    const name = await daoToken.name();
    const symbol = await daoToken.symbol();
    const totalSupply = await daoToken.totalSupply();

    console.log('decimals: ', decimals);
    console.log('symbol : ', symbol);
    console.log('name: ', name);
    console.log('total Supply: ', totalSupply);
    console.log('address: ', daoToken.address);
    assert.equal(symbol, 'DDD', 'symbol failed.');
    assert.equal(name, 'DAO Token Name', 'name failed.');
    assert.equal(totalSupply.toNumber(), 0, 'totalSupply failed.');

    //expect(totalSupply).to.equal(12);
  });

  it('mint 100 token to Zoe', async function () {
    //const daoAccessControl = await DaoAccessControl.deployed();
    const daoToken = await DaoToken.deployed();
    const decimals = await daoToken.decimals();
    const name = await daoToken.name();
    await daoToken.mint(user.Zoe, 100);

    console.log('minting ...........');
    const totalSupply = await daoToken.totalSupply();
    console.log('decimals: ', decimals);
    console.log('name: ', name);
    console.log('total Supply: ', totalSupply.toNumber());
    console.log('address: ', daoToken.address);
    assert.equal(totalSupply.toNumber(), 100, 'Write into admin name failed.');

    //expect(totalSupply).to.equal(12);
  });

  it('Zoe tranfer 50 tokens to Yue', async function () {
    const daoToken = await DaoToken.deployed();
    console.log('==============Before tranfer================');
    const zoeBalance_before = await daoToken.balanceOf(user.Zoe);
    const yueBalance_before = await daoToken.balanceOf(user.Yue);
    console.log('Zoe balance: ', zoeBalance_before.toNumber());
    console.log('Yue balance: ', yueBalance_before.toNumber());
    await daoToken.transfer(user.Zoe, user.Yue, 50);

    console.log('==============After tranfer================');
    const zoeBalance_after = await daoToken.balanceOf(user.Zoe);
    const yueBalance_after = await daoToken.balanceOf(user.Yue);
    console.log('Zoe balance: ', zoeBalance_after.toNumber());
    console.log('Yue balance: ', yueBalance_after.toNumber());

    console.log('address: ', daoToken.address);
    assert.equal(
      zoeBalance_after.toNumber(),
      50,
      'Write into admin name failed.'
    );
    assert.equal(
      yueBalance_after.toNumber(),
      50,
      'Write into admin name failed.'
    );

    //expect(totalSupply).to.equal(12);
  });
});
