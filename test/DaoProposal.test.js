const user = require('./accounts');
const DaoAccessControl = artifacts.require('./organization/DaoAccessControl');
const DaoRecord = artifacts.require('./organization/DaoRecord');
const DaoToken = artifacts.require('./organization/DaoToken');
const DaoProposal = artifacts.require('./organization/DaoProposal');

contract('DaoProposal', function () {

    it('Assign tokens and create a proposal to vote', async function () {

        let daoAccessControl = await DaoAccessControl.deployed();
        await daoAccessControl.grantAccountPermission("PROPOSAL_MANAGER", user.Yue, { from: user.Zoe });
        await daoAccessControl.grantAccountPermission("STAFF", user.Yue, { from: user.Zoe });
        await daoAccessControl.grantAccountPermission("STAFF", user.Home, { from: user.Zoe });
        await daoAccessControl.grantAccountPermission("STAFF", user.Mengjia, { from: user.Zoe });
        await daoAccessControl.grantAccountPermission("STAFF", user.Juncheng, { from: user.Zoe });
        await daoAccessControl.grantAccountPermission("STAFF", user.Minjia, { from: user.Zoe });
        await daoAccessControl.grantAccountPermission("STAFF", user.Diao, { from: user.Zoe });
        await daoAccessControl.grantAccountPermission("STAFF", user.Yichen, { from: user.Zoe });
        await daoAccessControl.grantAccountPermission("STAFF", user.Weijia, { from: user.Zoe });
        await daoAccessControl.grantAccountPermission("STAFF", user.Hexin, { from: user.Zoe });

        let daoToken = await DaoToken.deployed();
        await daoToken.mint(user.Zoe, 1000, { from: user.Zoe });
        await daoToken.mint(user.Yue, 2000, { from: user.Zoe });

        await daoToken.delegateFrom(user.Zoe, user.Zoe, { from: user.Zoe });
        await daoToken.delegateFrom(user.Yue, user.Yue, { from: user.Yue });
        await daoToken.delegateFrom(user.Home, user.Home, { from: user.Yue });
        await daoToken.delegateFrom(user.Mengjia, user.Mengjia, { from: user.Yue });
        await daoToken.delegateFrom(user.Juncheng, user.Juncheng, { from: user.Yue });
        await daoToken.delegateFrom(user.Minjia, user.Minjia, { from: user.Yue });
        await daoToken.delegateFrom(user.Diao, user.Diao, { from: user.Yue });
        await daoToken.delegateFrom(user.Yichen, user.Yichen, { from: user.Yue });
        await daoToken.delegateFrom(user.Weijia, user.Weijia, { from: user.Yue });
        await daoToken.delegateFrom(user.Hexin, user.Hexin, { from: user.Yue });

        await daoToken.transferFrom(user.Yue, user.Home, 200, { from: user.Yue });
        await daoToken.transferFrom(user.Yue, user.Mengjia, 150, { from: user.Yue });
        await daoToken.transferFrom(user.Yue, user.Juncheng, 140, { from: user.Yue });
        await daoToken.transferFrom(user.Yue, user.Minjia, 130, { from: user.Yue });
        await daoToken.transferFrom(user.Yue, user.Diao, 100, { from: user.Yue });
        await daoToken.transferFrom(user.Yue, user.Yichen, 100, { from: user.Yue });
        await daoToken.transferFrom(user.Yue, user.Weijia, 50, { from: user.Yue });
        await daoToken.transferFrom(user.Yue, user.Hexin, 50, { from: user.Yue });

        let daoProposal = await DaoProposal.deployed();
        let daoRecord = await DaoRecord.deployed();
        await daoAccessControl.grantAccountPermission("STAFF", daoProposal.address, { from: user.Zoe });
        await daoAccessControl.grantAccountPermission("RECORD_MANAGER", daoProposal.address, { from: user.Zoe });
        const proposalId = await daoProposal.propose(
            [daoRecord.address],
            [1000],
            [abi.encodeWithSignature("recordInformation(string)", "Slogan: Think Different.")], //todo
            "Minjia wants to record information of organizaitonal slogan in blockchain.",
            { from: user.Minjia }
        );

        //todo
        console.log("Everyone's weight:");
        const weightMinjia = await daoProposal.castVote(proposalId, uint8(VoteType.For), { from: user.Minjia });
        console.log("Minjia: ", weightMinjia);
        const weightZoe = await daoProposal.castVote(proposalId, uint8(VoteType.Against), { from: user.Zoe });
        console.log("Yue: ", weightZoe);
        const weightYue = await daoProposal.castVote(proposalId, uint8(VoteType.Against), { from: user.Yue });
        console.log("Yue: ", weightYue);
        const weightHome = await daoProposal.castVote(proposalId, uint8(VoteType.For), { from: user.Home });
        console.log("Home: ", weightHome);
        const weightMengjia = await daoProposal.castVote(proposalId, uint8(VoteType.For), { from: user.Mengjia });
        console.log("Mengjia: ", weightMengjia);
        const weightJuncheng = await daoProposal.castVote(proposalId, uint8(VoteType.abstainVotes), { from: user.Juncheng });
        console.log("Juncheng: ", weightJuncheng);
        const weightDiao = await daoProposal.castVote(proposalId, uint8(VoteType.For), { from: user.Diao });
        console.log("Diao: ", weightDiao);
        const weightYichen = await daoProposal.castVote(proposalId, uint8(VoteType.For), { from: user.Yichen });
        console.log("Yichen: ", weightYichen);
        const weightWeijia = await daoProposal.castVote(proposalId, uint8(VoteType.abstainVotes), { from: user.Weijia });
        console.log("Weijia: ", weightWeijia);
        const weightHexin = await daoProposal.castVote(proposalId, uint8(VoteType.Against), { from: user.Hexin });
        console.log("Hexin: ", weightHexin);


        //Just to guarantee the proposal has stopped after 10 blocknumbers.
        await daoProposal.hasVoted(proposalId, user.Zoe, { from: user.Yue });
        await daoProposal.hasVoted(proposalId, user.Home, { from: user.Yue });
        await daoProposal.hasVoted(proposalId, user.Mengjia, { from: user.Yue });

        await daoProposal.execute(
            [daoRecord.address],
            [1000],
            [abi.encodeWithSignature("recordInformation(string)", "Slogan: Think Different.")], //todo
            keccak256(bytes("Minjia wants to record information of organizaitonal slogan in blockchain.")), //todo
            { from: user.Minjia }
        );

        outputInfo = await daoRecord.inquiryInformation({ from: user.Home });

        expect(outputInfo).to.deep.equal("Slogan: Think Different.");
        
    });

});