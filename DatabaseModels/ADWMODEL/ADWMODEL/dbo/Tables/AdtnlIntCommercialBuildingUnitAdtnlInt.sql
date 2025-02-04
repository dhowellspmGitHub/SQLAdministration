CREATE TABLE [dbo].[AdtnlIntCommercialBuildingUnitAdtnlInt] (
    [AdditionalInterestId]                       INT           NOT NULL,
    [CommercialBuildingUnitAdditionalInterestId] INT           NOT NULL,
    [PolicyId]                                   INT           NOT NULL,
    [PolicyNbr]                                  VARCHAR (16)  NOT NULL,
    [UpdatedTmstmp]                              DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                              CHAR (8)      NOT NULL,
    [LastActionCd]                               CHAR (1)      NOT NULL,
    [SourceSystemCd]                             CHAR (2)      NOT NULL,
    CONSTRAINT [PK_AdtnlIntCommercialBuildingUnitAdtnlInt] PRIMARY KEY CLUSTERED ([AdditionalInterestId] ASC, [CommercialBuildingUnitAdditionalInterestId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AdditionalInterestCommercialBuildingUnitAdditionalInterest_CommercialBuildingUnitAdditionalInterest_01] FOREIGN KEY ([CommercialBuildingUnitAdditionalInterestId]) REFERENCES [dbo].[CommercialBuildingUnitAdditionalInterest] ([CommercialBuildingUnitAdditionalInterestId]),
    CONSTRAINT [FK_AdditionalInterestCommercialUnitAdditonalInterest_AdditionalInterest_01] FOREIGN KEY ([AdditionalInterestId]) REFERENCES [dbo].[AdditionalInterest] ([AdditionalInterestId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_AdtnlIntCommercialBuildingUnitAdtnlInt_01]
    ON [dbo].[AdtnlIntCommercialBuildingUnitAdtnlInt]([PolicyId] ASC)
    ON [POLICYCI];

