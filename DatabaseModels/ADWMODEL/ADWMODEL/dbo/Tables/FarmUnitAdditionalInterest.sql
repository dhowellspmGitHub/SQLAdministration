CREATE TABLE [dbo].[FarmUnitAdditionalInterest] (
    [FarmUnitAdditionalInterestId] INT           NOT NULL,
    [PolicyId]                     INT           NULL,
    [UnitNbr]                      INT           NULL,
    [UnitTypeCd]                   CHAR (1)      NULL,
    [PolicyNbr]                    VARCHAR (16)  NOT NULL,
    [ActiveMortgageeInd]           BIT           NOT NULL,
    [MortgageeSequenceNbr]         CHAR (3)      NULL,
    [MortgageeLoanNbr]             CHAR (15)     NULL,
    [PCAdditionalInterestNbr]      CHAR (10)     NULL,
    [InterestDesc]                 CHAR (30)     NULL,
    [ToTheAttentionOfNm]           VARCHAR (50)  NULL,
    [EscrowInd]                    CHAR (1)      NULL,
    [UpdatedTmstmp]                DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                CHAR (8)      NOT NULL,
    [LastActionCd]                 CHAR (1)      NOT NULL,
    [SourceSystemCd]               CHAR (2)      NOT NULL,
    CONSTRAINT [PK_FarmUnitAdditionalInterest] PRIMARY KEY CLUSTERED ([FarmUnitAdditionalInterestId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FarmUnitAdditionalInterest_FarmUnit_01] FOREIGN KEY ([PolicyId], [UnitNbr], [UnitTypeCd]) REFERENCES [dbo].[FarmUnit] ([PolicyId], [UnitNbr], [UnitTypeCd])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_FarmUnitAdditionalInterest_01]
    ON [dbo].[FarmUnitAdditionalInterest]([PolicyId] ASC, [PolicyNbr] ASC, [ActiveMortgageeInd] ASC, [MortgageeSequenceNbr] ASC)
    ON [POLICYCI];


GO
CREATE NONCLUSTERED INDEX [IX_FarmUnitAdditionalInterest_02]
    ON [dbo].[FarmUnitAdditionalInterest]([PolicyId] ASC)
    ON [POLICYCI];

