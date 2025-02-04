CREATE TABLE [dbo].[FireUnitAdditionalInterest] (
    [FireUnitAdditionalInterestId] INT           NOT NULL,
    [PolicyId]                     INT           NOT NULL,
    [UnitNbr]                      INT           NOT NULL,
    [PolicyNbr]                    VARCHAR (16)  NOT NULL,
    [ActiveMortgageeInd]           BIT           NOT NULL,
    [PCAdditionalInterestNbr]      CHAR (10)     NULL,
    [MortgageeSequenceNbr]         CHAR (1)      NULL,
    [MortgageeLoanNbr]             CHAR (15)     NULL,
    [InterestDesc]                 CHAR (30)     NULL,
    [ToTheAttentionOfNm]           VARCHAR (50)  NULL,
    [EscrowInd]                    CHAR (1)      NULL,
    [AdditionalInterestAlt1Nm]     CHAR (30)     NULL,
    [AdditionalInterestAlt2Nm]     CHAR (30)     NULL,
    [AdditionalInterestAlt3Nm]     CHAR (30)     NULL,
    [UpdatedTmstmp]                DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                CHAR (8)      NOT NULL,
    [LastActionCd]                 CHAR (1)      NOT NULL,
    [SourceSystemCd]               CHAR (2)      NOT NULL,
    CONSTRAINT [PK_FireUnitAdditionalInterest] PRIMARY KEY CLUSTERED ([FireUnitAdditionalInterestId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FireUnitAdditionalInterest_FireUnit_01] FOREIGN KEY ([PolicyId], [UnitNbr]) REFERENCES [dbo].[FireUnit] ([PolicyId], [UnitNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_FireUnitAdditionalInterest_01]
    ON [dbo].[FireUnitAdditionalInterest]([PolicyId] ASC, [PolicyNbr] ASC, [ActiveMortgageeInd] ASC, [MortgageeSequenceNbr] ASC)
    ON [POLICYCI];


GO
CREATE NONCLUSTERED INDEX [IX_FireUnitAdditionalInterest_02]
    ON [dbo].[FireUnitAdditionalInterest]([PolicyId] ASC)
    ON [POLICYCI];

