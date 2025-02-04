CREATE TABLE [dbo].[AdtnlIntCommercialBuildingQuoteUnitClassificationAdtnlInt] (
    [CommercialBuildingQuoteUnitClassificationAdditionalInterestId] INT           NOT NULL,
    [AdditionalInterestId]                                          INT           NOT NULL,
    [QuoteNbr]                                                      VARCHAR (16)  NULL,
    [UnitNbr]                                                       INT           NOT NULL,
    [ClassificationNbr]                                             INT           NULL,
    [UpdatedTmstmp]                                                 DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                                                 CHAR (8)      NOT NULL,
    [LastActionCd]                                                  CHAR (1)      NOT NULL,
    [SourceSystemCd]                                                CHAR (2)      NOT NULL,
    CONSTRAINT [PK_AdtnlIntCommercialBuildingQuoteUnitClassificationAdtnlInt] PRIMARY KEY CLUSTERED ([AdditionalInterestId] ASC, [CommercialBuildingQuoteUnitClassificationAdditionalInterestId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AdtnlIntCommercialBuildingQuoteUnitClassificationAdtnlInt_AdditionalInterest_01] FOREIGN KEY ([AdditionalInterestId]) REFERENCES [dbo].[AdditionalInterest] ([AdditionalInterestId]),
    CONSTRAINT [FK_AdtnlIntCommercialBuildingQuoteUnitClassificationAdtnlInt_CommercialBuildingQuoteUnitClassificationAdditionalInterest_01] FOREIGN KEY ([CommercialBuildingQuoteUnitClassificationAdditionalInterestId]) REFERENCES [dbo].[CommercialBuildingQuoteUnitClassificationAdditionalInterest] ([CommercialBuildingQuoteUnitClassificationAdditionalInterestId])
) ON [POLICYCD];

