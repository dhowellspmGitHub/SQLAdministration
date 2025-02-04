CREATE TABLE [dbo].[AdtnlIntMHQuoteUnitAdtnlInt] (
    [AdditionalInterestId]            INT           NOT NULL,
    [MHQuoteUnitAdditionalInterestId] INT           NOT NULL,
    [QuoteNbr]                        VARCHAR (16)  NOT NULL,
    [UnitNbr]                         INT           NOT NULL,
    [UpdatedTmstmp]                   DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                   CHAR (8)      NOT NULL,
    [LastActionCd]                    CHAR (1)      NOT NULL,
    [SourceSystemCd]                  CHAR (2)      NOT NULL,
    CONSTRAINT [PK_AdtnlIntMHQuoteUnitAdtnlInt] PRIMARY KEY CLUSTERED ([MHQuoteUnitAdditionalInterestId] ASC, [AdditionalInterestId] ASC, [QuoteNbr] ASC, [UnitNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AdditionalInterestMHQuoteUnitAdditonalInterest_AdditionalInterest_01] FOREIGN KEY ([AdditionalInterestId]) REFERENCES [dbo].[AdditionalInterest] ([AdditionalInterestId]),
    CONSTRAINT [FK_AdditionalInterestMHQuoteUnitAdditonalInterest_MobileHomeQuoteUnitAdditionalInterest_01] FOREIGN KEY ([MHQuoteUnitAdditionalInterestId], [QuoteNbr], [UnitNbr]) REFERENCES [dbo].[MobileHomeQuoteUnitAdditionalInterest] ([MHQuoteUnitAdditionalInterestId], [QuoteNbr], [UnitNbr])
) ON [POLICYCD];

