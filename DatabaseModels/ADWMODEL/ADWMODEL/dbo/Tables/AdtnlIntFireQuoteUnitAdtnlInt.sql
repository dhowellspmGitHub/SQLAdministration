CREATE TABLE [dbo].[AdtnlIntFireQuoteUnitAdtnlInt] (
    [AdditionalInterestId]              INT           NOT NULL,
    [FireQuoteUnitAdditionalInterestId] INT           NOT NULL,
    [QuoteNbr]                          VARCHAR (16)  NOT NULL,
    [UnitNbr]                           INT           NOT NULL,
    [UpdatedTmstmp]                     DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                     CHAR (8)      NOT NULL,
    [LastActionCd]                      CHAR (1)      NOT NULL,
    [SourceSystemCd]                    CHAR (2)      NOT NULL,
    CONSTRAINT [PK_AdtnlIntFireQuoteUnitAdtnlInt] PRIMARY KEY NONCLUSTERED ([AdditionalInterestId] ASC, [FireQuoteUnitAdditionalInterestId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AdditionalInterestFireQuoteUnitAdditonalInterest_AdditionalInterest_01] FOREIGN KEY ([AdditionalInterestId]) REFERENCES [dbo].[AdditionalInterest] ([AdditionalInterestId]),
    CONSTRAINT [FK_AdditionalInterestFireQuoteUnitAdditonalInterest_FireQuoteUnitAdditionalInterest_01] FOREIGN KEY ([FireQuoteUnitAdditionalInterestId]) REFERENCES [dbo].[FireQuoteUnitAdditionalInterest] ([FireQuoteUnitAdditionalInterestId])
) ON [POLICYCD];

