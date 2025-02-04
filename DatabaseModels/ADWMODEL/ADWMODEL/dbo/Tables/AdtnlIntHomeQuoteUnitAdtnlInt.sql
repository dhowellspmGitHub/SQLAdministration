CREATE TABLE [dbo].[AdtnlIntHomeQuoteUnitAdtnlInt] (
    [AdditionalInterestId]              INT           NOT NULL,
    [HomeQuoteUnitAdditionalInterestId] INT           NOT NULL,
    [UnitNbr]                           INT           NOT NULL,
    [QuoteNbr]                          VARCHAR (16)  NOT NULL,
    [UpdatedTmstmp]                     DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                     CHAR (8)      NOT NULL,
    [LastActionCd]                      CHAR (1)      NOT NULL,
    [SourceSystemCd]                    CHAR (2)      NOT NULL,
    CONSTRAINT [PK_AdtnlIntHomeQuoteUnitAdtnlInt] PRIMARY KEY CLUSTERED ([HomeQuoteUnitAdditionalInterestId] ASC, [AdditionalInterestId] ASC, [UnitNbr] ASC, [QuoteNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AdditionalInterestHomeQuoteUnitAdditonalInterest_AdditionalInterest_01] FOREIGN KEY ([AdditionalInterestId]) REFERENCES [dbo].[AdditionalInterest] ([AdditionalInterestId]),
    CONSTRAINT [FK_AdditionalInterestHomeQuoteUnitAdditonalInterest_HomeQuoteUnitAdditionalInterest_01] FOREIGN KEY ([HomeQuoteUnitAdditionalInterestId], [QuoteNbr], [UnitNbr]) REFERENCES [dbo].[HomeQuoteUnitAdditionalInterest] ([HomeQuoteUnitAdditionalInterestId], [QuoteNbr], [UnitNbr])
) ON [POLICYCD];

