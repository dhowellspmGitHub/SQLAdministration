CREATE TABLE [dbo].[CommercialBuildingQuoteUnitClassificationEndorsementDetail] (
    [CommercialBuildingQuoteUnitClassificationEndorsementDetailId] INT            NOT NULL,
    [QuoteNbr]                                                     VARCHAR (16)   NULL,
    [UnitNbr]                                                      INT            NULL,
    [ClassificationNbr]                                            INT            NULL,
    [EndorsementId]                                                INT            NULL,
    [EndorsementLimitAmt]                                          DECIMAL (9)    NULL,
    [EndorsementPremiumAmt]                                        DECIMAL (9, 2) NULL,
    [ItemBasicDesc]                                                VARCHAR (250)  NULL,
    [CreatedTmstmp]                                                DATETIME       NOT NULL,
    [UserCreatedId]                                                CHAR (8)       NOT NULL,
    [UpdatedTmstmp]                                                DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]                                                CHAR (8)       NOT NULL,
    [LastActionCd]                                                 CHAR (1)       NOT NULL,
    [SourceSystemCd]                                               CHAR (2)       NOT NULL,
    CONSTRAINT [PK_CommercialBuildingQuoteUnitClassificationEndorsementDetail] PRIMARY KEY CLUSTERED ([CommercialBuildingQuoteUnitClassificationEndorsementDetailId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialBuildingQuoteUnitClassificationEndorsementDetail_CommercialBuildingQuoteUnitClassificationEndorsement_01] FOREIGN KEY ([EndorsementId], [UnitNbr], [ClassificationNbr], [QuoteNbr]) REFERENCES [dbo].[CommercialBuildingQuoteUnitClassificationEndorsement] ([EndorsementId], [UnitNbr], [ClassificationNbr], [QuoteNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialBuildingQuoteUnitClassificationEndorsementDetail_01]
    ON [dbo].[CommercialBuildingQuoteUnitClassificationEndorsementDetail]([QuoteNbr] ASC)
    ON [POLICYCI];

