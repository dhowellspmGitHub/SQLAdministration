CREATE TABLE [dbo].[CommercialBuildingUnitClassificationEndorsementDetail] (
    [CommercialBuildingUnitClassificationEndorsementDetailId] INT            NOT NULL,
    [PolicyId]                                                INT            NOT NULL,
    [UnitNbr]                                                 INT            NOT NULL,
    [ClassificationNbr]                                       INT            NOT NULL,
    [EndorsementId]                                           INT            NOT NULL,
    [PolicyNbr]                                               VARCHAR (16)   NOT NULL,
    [EndorsementLimitAmt]                                     DECIMAL (9)    NULL,
    [EndorsementPremiumAmt]                                   DECIMAL (9, 2) NULL,
    [ItemBasicDesc]                                           VARCHAR (250)  NULL,
    [CreatedTmstmp]                                           DATETIME       NOT NULL,
    [UserCreatedId]                                           CHAR (8)       NOT NULL,
    [UpdatedTmstmp]                                           DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]                                           CHAR (8)       NOT NULL,
    [LastActionCd]                                            CHAR (1)       NOT NULL,
    [SourceSystemCd]                                          CHAR (2)       NOT NULL,
    CONSTRAINT [PK_CommercialBuildingUnitClassificationEndorsementDetail] PRIMARY KEY CLUSTERED ([CommercialBuildingUnitClassificationEndorsementDetailId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialBuildingUnitClassificationEndorsementDetail_CommercialBuildingUnitClassificationEndorsement_01] FOREIGN KEY ([EndorsementId], [PolicyId], [UnitNbr], [ClassificationNbr]) REFERENCES [dbo].[CommercialBuildingUnitClassificationEndorsement] ([EndorsementId], [PolicyId], [UnitNbr], [ClassificationNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialBuildingUnitClassificationEndorsementDetail_01]
    ON [dbo].[CommercialBuildingUnitClassificationEndorsementDetail]([PolicyId] ASC)
    ON [POLICYCI];

