CREATE TABLE [dbo].[AdtnlIntCommercialBuildingQuoteUnitAdtnlInt] (
    [AdditionalInterestId]                            INT           NOT NULL,
    [CommercialBuildingQuoteUnitAdditionalInterestId] INT           NOT NULL,
    [QuoteNbr]                                        VARCHAR (16)  NOT NULL,
    [UnitNbr]                                         INT           NOT NULL,
    [UpdatedTmstmp]                                   DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                                   CHAR (8)      NOT NULL,
    [LastActionCd]                                    CHAR (1)      NOT NULL,
    [SourceSystemCd]                                  CHAR (2)      NOT NULL,
    CONSTRAINT [PK_AdtnlIntCommercialBuildingQuoteUnitAdtnlInt] PRIMARY KEY CLUSTERED ([CommercialBuildingQuoteUnitAdditionalInterestId] ASC, [AdditionalInterestId] ASC, [QuoteNbr] ASC, [UnitNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AdditionalInterestCommercialBuildingQuoteUnitAdditionalInterest_AdditionalInterest_01] FOREIGN KEY ([AdditionalInterestId]) REFERENCES [dbo].[AdditionalInterest] ([AdditionalInterestId]),
    CONSTRAINT [FK_AdditionalInterestCommercialBuildingQuoteUnitAdditionalInterest_CommercialBuildingQuoteUnitAdditionalInterest_01] FOREIGN KEY ([CommercialBuildingQuoteUnitAdditionalInterestId], [QuoteNbr], [UnitNbr]) REFERENCES [dbo].[CommercialBuildingQuoteUnitAdditionalInterest] ([CommercialBuildingQuoteUnitAdditionalInterestId], [QuoteNbr], [UnitNbr])
) ON [POLICYCD];

