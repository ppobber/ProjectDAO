const user = require('./accounts');
const DaoAccessControl = artifacts.require('./organization/DaoAccessControl');
const DaoRecord = artifacts.require('./organization/DaoRecord');
const DaoToken = artifacts.require('./organization/DaoToken');
const DaoProposal = artifacts.require('./organization/DaoProposal');
const DaoProposalRecord = artifacts.require('./organization/DaoProposalRecord');

contract('DaoProposal', function () {

    it('Assign tokens and create a proposal to vote', async function () {


        let daoAccessControl = await DaoAccessControl.deployed();
        await daoAccessControl.grantAccountPermission("PROPOSAL_MANAGER", user.Yue, { from: user.Zoe });
        await daoAccessControl.grantAccountPermission("TOKEN_MANAGER", user.Home, { from: user.Zoe });
        await daoAccessControl.grantAccountPermission("RECORD_MANAGER", user.Mengjia, { from: user.Zoe });
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

        await daoToken.delegateFrom(user.Zoe, user.Zoe, { from: user.Home });
        await daoToken.delegateFrom(user.Yue, user.Yue, { from: user.Home });
        await daoToken.delegateFrom(user.Home, user.Home, { from: user.Home });
        await daoToken.delegateFrom(user.Mengjia, user.Mengjia, { from: user.Home });
        await daoToken.delegateFrom(user.Juncheng, user.Juncheng, { from: user.Home });
        await daoToken.delegateFrom(user.Minjia, user.Minjia, { from: user.Home });
        await daoToken.delegateFrom(user.Diao, user.Diao, { from: user.Home });
        await daoToken.delegateFrom(user.Yichen, user.Yichen, { from: user.Home });
        await daoToken.delegateFrom(user.Weijia, user.Weijia, { from: user.Home });
        await daoToken.delegateFrom(user.Hexin, user.Hexin, { from: user.Home });
        console.log("Everyone has get delegate.");

        await daoToken.transferFrom(user.Yue, user.Home, 200, { from: user.Home });
        await daoToken.transferFrom(user.Yue, user.Mengjia, 150, { from: user.Home });
        await daoToken.transferFrom(user.Yue, user.Juncheng, 140, { from: user.Home });
        await daoToken.transferFrom(user.Yue, user.Minjia, 130, { from: user.Home });
        await daoToken.transferFrom(user.Yue, user.Diao, 100, { from: user.Home });
        await daoToken.transferFrom(user.Yue, user.Yichen, 100, { from: user.Home });
        await daoToken.transferFrom(user.Yue, user.Weijia, 50, { from: user.Home });
        await daoToken.transferFrom(user.Yue, user.Hexin, 50, { from: user.Home });
        console.log("Everyone has been assigned money.");

        let daoRecord = await DaoRecord.deployed();
        let daoProposal = await DaoProposal.deployed();
        let daoProposalRecord = await DaoProposalRecord.deployed();

        await daoProposalRecord.createProposal(
            "Record organizaitonal new slogan in blockchain. Proposer: Minjia",
            { from: user.Minjia }
        );
        const proposalNumber = await daoProposalRecord.inquiryLatestProposalNumber({ from: user.Minjia });

        await daoProposalRecord.addRecordBehavior(proposalNumber, "Slogan: Think Different.", { from: user.Minjia });

        // await daoProposalRecord.addTransferEthBehavior(
        //     proposalNumber, user.Yichen, web3.utils.toWei("1", "ether"),
        //     { from: user.Minjia, value: web3.utils.toWei("1.1", "ether") });
        
        await daoProposalRecord.addMintTokenBehavior(proposalNumber, user.Yichen, 22, { from: user.Minjia });
        console.log("Minjia creates a proposal.");

        const stateNow1 = await daoProposalRecord.inquiryProposalState(proposalNumber, { from: user.Hexin });
        expect(stateNow1).to.equal("Unreleased");

        // await daoProposalRecord.releaseProposal(proposalNumber, { from: user.Yue });
        await daoProposalRecord.releaseProposalWithSetting(proposalNumber, 0, 11, 0, 0, { from: user.Yue });

        const proposalId = await daoProposalRecord.inquiryProposalId(proposalNumber, { from: user.Yue });

        // const stateNow2 = await daoProposalRecord.inquiryProposalState(proposalNumber, { from: user.Hexin });
        // expect(stateNow2).to.equal("Pending");

        const Against = 0;
        const For = 1;
        const Abstain = 2;

        await daoProposal.castVote(proposalId, For, { from: user.Minjia });
        await daoProposal.castVote(proposalId, For, { from: user.Zoe });
        await daoProposal.castVote(proposalId, For, { from: user.Yue });
        await daoProposal.castVote(proposalId, Against, { from: user.Home });
        await daoProposal.castVote(proposalId, Against, { from: user.Mengjia });
        await daoProposal.castVote(proposalId, Abstain, { from: user.Juncheng });
        await daoProposal.castVote(proposalId, Against, { from: user.Diao });
        await daoProposal.castVote(proposalId, For, { from: user.Yichen });
        await daoProposal.castVote(proposalId, Abstain, { from: user.Weijia });
        await daoProposal.castVote(proposalId, Against, { from: user.Hexin });

        await daoToken.transferFrom(user.Yue, user.Minjia, 1, { from: user.Home });
        await daoToken.transferFrom(user.Yue, user.Diao, 1, { from: user.Home });
        await daoToken.transferFrom(user.Yue, user.Yichen, 1, { from: user.Home });
        await daoToken.transferFrom(user.Yue, user.Weijia, 1, { from: user.Home });
        await daoToken.transferFrom(user.Yue, user.Hexin, 1, { from: user.Home });
        await daoToken.transferFrom(user.Yue, user.Zoe, 2, { from: user.Home });

        // const isZoeVote = await daoProposal.hasVoted(proposalId, user.Zoe, { from: user.Juncheng });
        // expect(isZoeVote).to.be.true;
        // const isHomeVote = await daoProposal.hasVoted(proposalId, user.Home, { from: user.Juncheng });
        // expect(isHomeVote).to.be.true;
        // const isMengjiaVote = await daoProposal.hasVoted(proposalId, user.Mengjia, { from: user.Juncheng });
        // expect(isMengjiaVote).to.be.true;

        const proposalInformation = await daoProposalRecord.inquiryProposalInformation(proposalNumber, { from: user.Diao });
        console.log("Proposal information:");
        console.log(proposalInformation);

        const stateNow3 = await daoProposalRecord.inquiryProposalState(proposalNumber, { from: user.Hexin });
        expect(stateNow3).to.equal("Succeeded");

        await daoProposalRecord.executeProposal(proposalNumber, { from: user.Yue });

        const stateNow4 = await daoProposalRecord.inquiryProposalState(proposalNumber, { from: user.Weijia });
        expect(stateNow4).to.equal("Executed");

        outputRecordInfo = await daoRecord.inquiryInformation({ from: user.Mengjia });
        console.log("Recorded information: ", outputRecordInfo);
        outputSupply = await daoToken.totalSupply({ from: user.Home });
        console.log("Total supply: ", outputSupply.toNumber());
        outputBalance = await daoToken.balanceOf(user.Yichen, { from: user.Home });
        console.log("Yichen Balance: ", outputBalance.toNumber());

        // expect(outputRecordInfo).to.deep.equal("Slogan: Think Different.");
        
    });

});











































