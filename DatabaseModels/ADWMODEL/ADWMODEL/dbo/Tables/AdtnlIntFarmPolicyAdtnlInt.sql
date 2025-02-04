CREATE TABLE [dbo].[AdtnlIntFarmPolicyAdtnlInt] (
    [AdditionalInterestId]   INT           NOT NULL,
    [FarmPolicyAdditionalId] INT           NOT NULL,
    [PolicyId]               INT           NOT NULL,
    [PolicyNbr]              VARCHAR (16)  NOT NULL,
    [UpdatedTmstmp]          DATETIME2 (7) NOT NULL,
    [UserUpdatedId]          CHAR (8)      NOT NULL,
    [LastActionCd]           CHAR (1)      NOT NULL,
    [SourceSystemCd]         CHAR (2)      NOT NULL,
    CONSTRAINT [PK_AdtnlIntFarmPolicyAdtnlInt] PRIMARY KEY CLUSTERED ([FarmPolicyAdditionalId] ASC, [PolicyId] ASC, [AdditionalInterestId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AdditionalInterestFarmPolicyAdditionalInterest_AdditionalInterest_01] FOREIGN KEY ([AdditionalInterestId]) REFERENCES [dbo].[AdditionalInterest] ([AdditionalInterestId]),
    CONSTRAINT [FK_AdditionalInterestFarmPolicyAdditionalInterest_FarmPolicyAdditionalInterest_01] FOREIGN KEY ([PolicyId], [FarmPolicyAdditionalId]) REFERENCES [dbo].[FarmPolicyAdditionalInterest] ([PolicyId], [FarmPolicyAdditionalId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_AdtnlIntFarmPolicyAdtnlInt_01]
    ON [dbo].[AdtnlIntFarmPolicyAdtnlInt]([PolicyId] ASC)
    ON [POLICYCI];

