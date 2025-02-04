CREATE TABLE [dbo].[AdditionalInterestCommercialQuoteAdditionalInterest] (
    [CommercialBuildingQuoteUnitClassificationAdditionalInterestId] INT           NOT NULL,
    [AdditionalInterestId]                                          INT           NOT NULL,
    [CommercialQuoteAdditionalId]                                   INT           NOT NULL,
    [QuoteNbr]                                                      VARCHAR (16)  NOT NULL,
    [UpdatedTmstmp]                                                 DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                                                 CHAR (8)      NOT NULL,
    [LastActionCd]                                                  CHAR (1)      NOT NULL,
    [SourceSystemCd]                                                CHAR (2)      NOT NULL,
    CONSTRAINT [PK_AdditionalInterestCommercialQuoteAdditionalInterest] PRIMARY KEY CLUSTERED ([CommercialBuildingQuoteUnitClassificationAdditionalInterestId] ASC, [QuoteNbr] ASC, [AdditionalInterestId] ASC, [CommercialQuoteAdditionalId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AdditionalInterestCommercialQuoteAdditionalInterest_AdditionalInterest_01] FOREIGN KEY ([AdditionalInterestId]) REFERENCES [dbo].[AdditionalInterest] ([AdditionalInterestId]),
    CONSTRAINT [FK_AdditionalInterestCommercialQuoteAdditionalInterest_CommercialQuoteAdditionalInterest_01] FOREIGN KEY ([CommercialQuoteAdditionalId]) REFERENCES [dbo].[CommercialQuoteAdditionalInterest] ([CommercialQuoteAdditionalId])
) ON [POLICYCD];

