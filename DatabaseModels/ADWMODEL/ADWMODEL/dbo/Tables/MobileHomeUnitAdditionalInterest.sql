CREATE TABLE [dbo].[MobileHomeUnitAdditionalInterest] (
    [UnitAdditionalInterestId] INT           NOT NULL,
    [PolicyId]                 INT           NOT NULL,
    [UnitNbr]                  INT           NOT NULL,
    [PolicyNbr]                VARCHAR (16)  NOT NULL,
    [PCAdditionalInterestNbr]  CHAR (10)     NULL,
    [ActiveMortgageeInd]       BIT           NOT NULL,
    [MortgageeLoanNbr]         CHAR (15)     NULL,
    [InterestDesc]             CHAR (30)     NULL,
    [MortgageeSequenceNbr]     CHAR (1)      NULL,
    [ToTheAttentionOfNm]       VARCHAR (50)  NULL,
    [EscrowInd]                CHAR (1)      NULL,
    [AdditionalInterestAlt1Nm] CHAR (30)     NULL,
    [AdditionalInterestAlt2Nm] CHAR (30)     NULL,
    [AdditionalInterestAlt3Nm] CHAR (30)     NULL,
    [UpdatedTmstmp]            DATETIME2 (7) NOT NULL,
    [UserUpdatedId]            CHAR (8)      NOT NULL,
    [LastActionCd]             CHAR (1)      NOT NULL,
    [SourceSystemCd]           CHAR (2)      NOT NULL,
    CONSTRAINT [PK_MobileHomeUnitAdditionalInterest] PRIMARY KEY CLUSTERED ([UnitAdditionalInterestId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_MobileHomeUnitAdditionalInterest_MobileHomeUnit_01] FOREIGN KEY ([PolicyId], [UnitNbr]) REFERENCES [dbo].[MobileHomeUnit] ([PolicyId], [UnitNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_MobileHomeUnitAdditionalInterest_01]
    ON [dbo].[MobileHomeUnitAdditionalInterest]([PolicyId] ASC, [PolicyNbr] ASC, [ActiveMortgageeInd] ASC, [MortgageeSequenceNbr] ASC)
    ON [POLICYCI];


GO
CREATE NONCLUSTERED INDEX [IX_MobileHomeUnitAdditionalInterest_02]
    ON [dbo].[MobileHomeUnitAdditionalInterest]([PolicyId] ASC)
    ON [POLICYCI];

