CREATE TABLE [dbo].[AdtnlIntBoatQuoteUnitAdtnlInt] (
    [AdditionalInterestId]              INT           NOT NULL,
    [BoatQuoteUnitAdditionalInterestId] INT           NOT NULL,
    [UnitNbr]                           INT           NOT NULL,
    [QuoteNbr]                          VARCHAR (16)  NOT NULL,
    [UpdatedTmstmp]                     DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                     CHAR (8)      NOT NULL,
    [LastActionCd]                      CHAR (1)      NOT NULL,
    [SourceSystemCd]                    CHAR (2)      NOT NULL,
    CONSTRAINT [PK_AdtnlIntBoatQuoteUnitAdtnlInt] PRIMARY KEY CLUSTERED ([BoatQuoteUnitAdditionalInterestId] ASC, [AdditionalInterestId] ASC, [UnitNbr] ASC, [QuoteNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AdditionalInterestBoatQuoteUnitAdditonalInterest_AdditionalInterest_01] FOREIGN KEY ([AdditionalInterestId]) REFERENCES [dbo].[AdditionalInterest] ([AdditionalInterestId]),
    CONSTRAINT [FK_AdditionalInterestBoatQuoteUnitAdditonalInterest_BoatQuoteUnitAdditionalInterest_01] FOREIGN KEY ([BoatQuoteUnitAdditionalInterestId], [QuoteNbr], [UnitNbr]) REFERENCES [dbo].[BoatQuoteUnitAdditionalInterest] ([BoatQuoteUnitAdditionalInterestId], [QuoteNbr], [UnitNbr])
) ON [POLICYCD];

