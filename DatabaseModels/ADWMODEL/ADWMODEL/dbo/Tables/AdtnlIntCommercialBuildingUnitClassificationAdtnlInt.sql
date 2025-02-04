CREATE TABLE [dbo].[AdtnlIntCommercialBuildingUnitClassificationAdtnlInt] (
    [AdditionalInterestId]                                     INT           NOT NULL,
    [CommercialBuildingUnitClassificationAdditionalInterestId] INT           NOT NULL,
    [PolicyId]                                                 INT           NOT NULL,
    [PolicyNbr]                                                VARCHAR (16)  NOT NULL,
    [UpdatedTmstmp]                                            DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                                            CHAR (8)      NOT NULL,
    [LastActionCd]                                             CHAR (1)      NOT NULL,
    [SourceSystemCd]                                           CHAR (2)      NOT NULL,
    CONSTRAINT [PK_AdtnlIntCommercialBuildingUnitClassificationAdtnlInt] PRIMARY KEY CLUSTERED ([AdditionalInterestId] ASC, [CommercialBuildingUnitClassificationAdditionalInterestId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AdtnlIntCommercialBuildingUnitClassificationAdtnlInt_AdditionalInterest_01] FOREIGN KEY ([AdditionalInterestId]) REFERENCES [dbo].[AdditionalInterest] ([AdditionalInterestId]),
    CONSTRAINT [FK_AdtnlIntCommercialBuildingUnitClassificationAdtnlInt_CommercialBuildingUnitClassificationAdditionalInterest_01] FOREIGN KEY ([CommercialBuildingUnitClassificationAdditionalInterestId]) REFERENCES [dbo].[CommercialBuildingUnitClassificationAdditionalInterest] ([CommercialBuildingUnitClassificationAdditionalInterestId])
) ON [POLICYCD];

