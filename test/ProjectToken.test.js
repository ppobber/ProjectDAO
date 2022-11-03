const user = require('./accounts');
const ProjectToken = artifacts.require('./project/ProjectToken');

contract('ProjectToken', function () {

  it('Check name and tokens symbol', async function () {
    const projectToken = await ProjectToken.deployed();
    const decimals = await projectToken.decimals();
    const name = await projectToken.name();
    const symbol = await projectToken.symbol();
    const totalSupply = await projectToken.totalSupply();

    console.log('decimals: ', decimals);
    console.log('symbol : ', symbol);
    console.log('name: ', name);
    console.log('total Supply: ', totalSupply);
    console.log('address: ', projectToken.address);
    assert.equal(symbol, 'PPP', 'symbol failed.');
    assert.equal(name, 'ProjectTokenNameForTest', 'name failed.');
    assert.equal(totalSupply.toNumber(), 0, 'totalSupply failed.');

    //expect(totalSupply).to.equal(12);
  });

  it('mint 100 token to Zoe', async function () {
    const projectToken = await ProjectToken.deployed();
    const decimals = await projectToken.decimals();
    const name = await projectToken.name();
    await projectToken.mint(user.Zoe, 100);

    console.log('minting ...........');
    const totalSupply = await projectToken.totalSupply();
    console.log('address: ', projectToken.address);
    assert.equal(totalSupply.toNumber(), 100, 'mint 100 token failed.');

    //expect(totalSupply).to.equal(12);
  });

  it('Zoe tranfer 50 tokens to Yue', async function () {
    const projectToken = await ProjectToken.deployed();
    console.log('==============Before tranfer================');
    const zoeBalance_before = await projectToken.balanceOf(user.Zoe);
    const yueBalance_before = await projectToken.balanceOf(user.Yue);
    console.log('Zoe balance: ', zoeBalance_before.toNumber());
    console.log('Yue balance: ', yueBalance_before.toNumber());
    await projectToken.transfer(user.Zoe, user.Yue, 50);

    console.log('==============After tranfer================');
    const zoeBalance_after = await projectToken.balanceOf(user.Zoe);
    const yueBalance_after = await projectToken.balanceOf(user.Yue);
    console.log('Zoe balance: ', zoeBalance_after.toNumber());
    console.log('Yue balance: ', yueBalance_after.toNumber());

    console.log('address: ', projectToken.address);
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
