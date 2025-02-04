CREATE TABLE [dbo].[MobileHomeQuoteUnitAdditionalInterest] (
    [MHQuoteUnitAdditionalInterestId] INT           NOT NULL,
    [QuoteNbr]                        VARCHAR (16)  NOT NULL,
    [UnitNbr]                         INT           NOT NULL,
    [PCAdditionalInterestNbr]         CHAR (10)     NULL,
    [MortgageeLoanNbr]                CHAR (15)     NULL,
    [InterestDesc]                    CHAR (30)     NULL,
    [MortgageeSequenceNbr]            CHAR (1)      NULL,
    [EscrowInd]                       CHAR (1)      NULL,
    [AdditionalInterestAlt1Nm]        CHAR (30)     NULL,
    [AdditionalInterestAlt2Nm]        CHAR (30)     NULL,
    [AdditionalInterestAlt3Nm]        CHAR (30)     NULL,
    [UpdatedTmstmp]                   DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                   CHAR (8)      NOT NULL,
    [LastActionCd]                    CHAR (1)      NOT NULL,
    [SourceSystemCd]                  CHAR (2)      NOT NULL,
    CONSTRAINT [PK_MobileHomeQuoteUnitAdditionalInterest] PRIMARY KEY CLUSTERED ([MHQuoteUnitAdditionalInterestId] ASC, [QuoteNbr] ASC, [UnitNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_MobileHomeQuoteUnitAdditionalInterest_MobileHomeQuoteUnit_01] FOREIGN KEY ([QuoteNbr], [UnitNbr]) REFERENCES [dbo].[MobileHomeQuoteUnit] ([QuoteNbr], [UnitNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_MobileHomeQuoteUnitAdditionalInterest_01]
    ON [dbo].[MobileHomeQuoteUnitAdditionalInterest]([QuoteNbr] ASC)
    ON [POLICYCI];

