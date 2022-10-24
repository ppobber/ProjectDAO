const { copySync } = require('fs-extra');

const ProjectToken = artifacts.require('./project-name1/ProjectToken');
contract('ProjectToken', function (accounts) {
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

  it('Check name and tokens symbol', async () => {
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
    assert.equal(name, 'ProjectTokenNameForScript', 'name failed.');
    assert.equal(totalSupply.toNumber(), 0, 'totalSupply failed.');

    //expect(totalSupply).to.equal(12);
  });

  it('mint 100 token to Zoe', async () => {
    const projectToken = await ProjectToken.deployed();
    const decimals = await projectToken.decimals();
    const name = await projectToken.name();
    await projectToken.mint(accounts[0], 100);

    console.log('minting ...........');
    const totalSupply = await projectToken.totalSupply();
    console.log('address: ', projectToken.address);
    assert.equal(totalSupply.toNumber(), 100, 'mint 100 token failed.');

    //expect(totalSupply).to.equal(12);
  });

  it('Zoe tranfer 50 tokens to Yue', async () => {
    const projectToken = await ProjectToken.deployed();
    console.log('==============Before tranfer================');
    const zoeBalance_before = await projectToken.balanceOf(user_Zoe);
    const yueBalance_before = await projectToken.balanceOf(user_Yue);
    console.log('Zoe balance: ', zoeBalance_before.toNumber());
    console.log('Yue balance: ', yueBalance_before.toNumber());
    await projectToken.transfer(user_Zoe, user_Yue, 50);

    console.log('==============After tranfer================');
    const zoeBalance_after = await projectToken.balanceOf(user_Zoe);
    const yueBalance_after = await projectToken.balanceOf(user_Yue);
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
