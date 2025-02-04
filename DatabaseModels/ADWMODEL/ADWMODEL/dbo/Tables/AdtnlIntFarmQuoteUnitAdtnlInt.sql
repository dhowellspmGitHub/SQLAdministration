CREATE TABLE [dbo].[AdtnlIntFarmQuoteUnitAdtnlInt] (
    [AdditionalInterestId]              INT           NOT NULL,
    [FarmQuoteUnitAdditionalInterestId] INT           NOT NULL,
    [QuoteNbr]                          VARCHAR (16)  NOT NULL,
    [UnitNbr]                           INT           NOT NULL,
    [UpdatedTmstmp]                     DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                     CHAR (8)      NOT NULL,
    [LastActionCd]                      CHAR (1)      NOT NULL,
    [SourceSystemCd]                    CHAR (2)      NOT NULL,
    CONSTRAINT [PK_AdtnlIntFarmQuoteUnitAdtnlInt] PRIMARY KEY CLUSTERED ([FarmQuoteUnitAdditionalInterestId] ASC, [AdditionalInterestId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AdditionalInterestFarmQuoteUnitAdditionalInterest_AdditionalInterest_01] FOREIGN KEY ([AdditionalInterestId]) REFERENCES [dbo].[AdditionalInterest] ([AdditionalInterestId]),
    CONSTRAINT [FK_AdditionalInterestFarmQuoteUnitAdditionalInterest_FarmQuoteUnitAdditionalInterest_01] FOREIGN KEY ([FarmQuoteUnitAdditionalInterestId]) REFERENCES [dbo].[FarmQuoteUnitAdditionalInterest] ([FarmQuoteUnitAdditionalInterestId])
) ON [POLICYCD];

