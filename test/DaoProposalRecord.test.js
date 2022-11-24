const user = require('./accounts');
const DaoProposalRecord = artifacts.require('./organization/DaoProposalRecord');
const DaoToken = artifacts.require('./organization/DaoToken');

contract('DaoProposal', function () {

    it.only('Assign tokens and create a proposal to vote', async function () {
        const daoProposalRecord = await DaoProposalRecord.deployed();

        await daoProposalRecord.createProposal(
            "Minjia wants to record information of organizaitonal slogan in blockchain.",
            { from: user.Zoe }
        );

        const proposalNumber = await daoProposalRecord.inquiryLatestProposalNumber({ from: user.Zoe });

        await daoProposalRecord.addRecordBehavior(proposalNumber, "Slogan: Think Different.", { from: user.Zoe });

        const stateNow2 = await daoProposalRecord.inquiryProposalState(proposalNumber, { from: user.Zoe });
        expect(stateNow2).to.equal("Unreleased");

        const proposalInformation = await daoProposalRecord.inquiryProposalInformation(proposalNumber, { from: user.Zoe });
        console.log("Proposal information:");
        console.log(proposalInformation);
        
    });

});