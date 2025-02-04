CREATE TABLE [dbo].[CommercialBuildingQuoteUnitClassificationEndorsement] (
    [QuoteNbr]                     VARCHAR (16)    NOT NULL,
    [UnitNbr]                      INT             NOT NULL,
    [ClassificationNbr]            INT             NOT NULL,
    [EndorsementId]                INT             NOT NULL,
    [EndorsementNbr]               CHAR (10)       NOT NULL,
    [CashUnitNbr]                  CHAR (3)        NULL,
    [EndorsementLimitCd]           CHAR (3)        NULL,
    [EndorsementLimitAmt]          DECIMAL (9)     NULL,
    [EndorsementPremiumAmt]        DECIMAL (9, 2)  NULL,
    [IncreasedLimitAmt]            DECIMAL (9)     NULL,
    [PropertyDesc]                 VARCHAR (255)   NULL,
    [DeductibleAmt]                DECIMAL (18, 2) NULL,
    [AdvertisingLimitAmt]          DECIMAL (9)     NULL,
    [IncreasedAdvertisingLimitAmt] DECIMAL (9)     NULL,
    [CommunicationSupplyDesc]      VARCHAR (255)   NULL,
    [PowerSupplyDesc]              VARCHAR (255)   NULL,
    [CreatedTmstmp]                DATETIME        NOT NULL,
    [UserCreatedId]                CHAR (8)        NOT NULL,
    [UpdatedTmstmp]                DATETIME2 (7)   NOT NULL,
    [UserUpdatedId]                CHAR (8)        NOT NULL,
    [LastActionCd]                 CHAR (1)        NOT NULL,
    [SourceSystemCd]               CHAR (2)        NOT NULL,
    CONSTRAINT [PK_CommercialBuildingQuoteUnitClassificationEndorsement] PRIMARY KEY CLUSTERED ([EndorsementId] ASC, [UnitNbr] ASC, [ClassificationNbr] ASC, [QuoteNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialBuildingQuoteUnitClassificationEndorsement_CommercialBuildingQuoteUnitClassification_01] FOREIGN KEY ([ClassificationNbr], [UnitNbr], [QuoteNbr]) REFERENCES [dbo].[CommercialBuildingQuoteUnitClassification] ([ClassificationNbr], [UnitNbr], [QuoteNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialBuildingQuoteUnitClassificationEndorsement_01]
    ON [dbo].[CommercialBuildingQuoteUnitClassificationEndorsement]([QuoteNbr] ASC)
    ON [POLICYCI];

