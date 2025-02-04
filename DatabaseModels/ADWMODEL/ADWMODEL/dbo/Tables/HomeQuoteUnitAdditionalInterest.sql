CREATE TABLE [dbo].[HomeQuoteUnitAdditionalInterest] (
    [HomeQuoteUnitAdditionalInterestId] INT           NOT NULL,
    [UnitNbr]                           INT           NOT NULL,
    [QuoteNbr]                          VARCHAR (16)  NOT NULL,
    [PCAdditionalInterestNbr]           CHAR (10)     NULL,
    [MortgageeSequenceNbr]              CHAR (1)      NULL,
    [MortgageeLoanNbr]                  CHAR (15)     NULL,
    [InterestDesc]                      CHAR (30)     NULL,
    [EscrowInd]                         CHAR (1)      NULL,
    [AdditionalInterestAlt1Nm]          CHAR (30)     NULL,
    [AdditionalInterestAlt2Nm]          CHAR (30)     NULL,
    [AdditionalInterestAlt3Nm]          CHAR (30)     NULL,
    [UpdatedTmstmp]                     DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                     CHAR (8)      NOT NULL,
    [LastActionCd]                      CHAR (1)      NOT NULL,
    [SourceSystemCd]                    CHAR (2)      NOT NULL,
    CONSTRAINT [PK_HomeQuoteUnitAdditionalInterest] PRIMARY KEY CLUSTERED ([HomeQuoteUnitAdditionalInterestId] ASC, [QuoteNbr] ASC, [UnitNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_HomeQuoteUnitAdditionalInterest_HomeQuoteUnit_01] FOREIGN KEY ([QuoteNbr], [UnitNbr]) REFERENCES [dbo].[HomeQuoteUnit] ([QuoteNbr], [UnitNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_HomeQuoteUnitAdditionalInterest_01]
    ON [dbo].[HomeQuoteUnitAdditionalInterest]([QuoteNbr] ASC)
    ON [POLICYCI];

