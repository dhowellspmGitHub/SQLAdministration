CREATE TABLE [dbo].[CommercialBuildingUnitClassificationAdditionalInterest] (
    [CommercialBuildingUnitClassificationAdditionalInterestId] INT           NOT NULL,
    [PolicyId]                                                 INT           NOT NULL,
    [UnitNbr]                                                  INT           NOT NULL,
    [ClassificationNbr]                                        INT           NOT NULL,
    [PolicyNbr]                                                VARCHAR (16)  NOT NULL,
    [MortgageeSequenceNbr]                                     CHAR (3)      NULL,
    [MortgageeLoanNbr]                                         CHAR (35)     NULL,
    [PCAdditionalInterestNbr]                                  CHAR (10)     NULL,
    [InterestDesc]                                             VARCHAR (255) NULL,
    [ToTheAttentionOfNm]                                       VARCHAR (50)  NULL,
    [EscrowInd]                                                CHAR (1)      NULL,
    [CreatedTmstmp]                                            DATETIME      NOT NULL,
    [UserCreatedId]                                            CHAR (8)      NOT NULL,
    [UpdatedTmstmp]                                            DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                                            CHAR (8)      NOT NULL,
    [LastActionCd]                                             CHAR (1)      NOT NULL,
    [SourceSystemCd]                                           CHAR (2)      NOT NULL,
    CONSTRAINT [PK_CommercialBuildingUnitClassificationAdditionalInterest] PRIMARY KEY CLUSTERED ([CommercialBuildingUnitClassificationAdditionalInterestId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialBuildingUnitClassificationAdditionalInterest_CommercialBuildingUnitClassification_01] FOREIGN KEY ([PolicyId], [UnitNbr], [ClassificationNbr]) REFERENCES [dbo].[CommercialBuildingUnitClassification] ([PolicyId], [UnitNbr], [ClassificationNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialBuildingUnitClassificationAdditionalInterest_01]
    ON [dbo].[CommercialBuildingUnitClassificationAdditionalInterest]([PolicyId] ASC)
    ON [POLICYCI];

