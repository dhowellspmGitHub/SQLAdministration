CREATE TABLE [dbo].[CommercialGLQuoteEndorsementDetail] (
    [QuoteNbr]                             VARCHAR (16)   NOT NULL,
    [CommercialGLQuoteEndorsementDetailId] INT            NOT NULL,
    [EndorsementNbr]                       CHAR (10)      NOT NULL,
    [EndorsementId]                        INT            NOT NULL,
    [LocationID]                           BIGINT         NULL,
    [QuoteAdditionalInsuredId]             BIGINT         NULL,
    [ItemNbr]                              CHAR (3)       NOT NULL,
    [ItemBasicDesc]                        VARCHAR (250)  NULL,
    [EndorsementLimitAmt]                  DECIMAL (9)    NULL,
    [EndorsementPremiumAmt]                DECIMAL (9, 2) NULL,
    [HazzardDesc]                          VARCHAR (255)  NULL,
    [IncludedExcludedCountryNm]            VARCHAR (255)  NULL,
    [LocationDesc]                         VARCHAR (255)  NULL,
    [EquipmentSerialNbr]                   CHAR (20)      NULL,
    [ManufacturerNm]                       VARCHAR (50)   NULL,
    [ModelNm]                              VARCHAR (100)  NULL,
    [ManufacturingYearDt]                  CHAR (4)       NULL,
    [PurchaseYearDt]                       CHAR (4)       NULL,
    [EndorsementPremiumManualAmt]          DECIMAL (9, 2) NULL,
    [PersonOrOrganizationNm]               VARCHAR (512)  NULL,
    [CreatedTmstmp]                        DATETIME       NOT NULL,
    [UserCreatedId]                        CHAR (8)       NOT NULL,
    [UpdatedTmstmp]                        DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]                        CHAR (8)       NOT NULL,
    [LastActionCd]                         CHAR (1)       NOT NULL,
    [SourceSystemCd]                       CHAR (2)       NOT NULL,
    CONSTRAINT [PK_CommercialGLQuoteEndorsementDetail] PRIMARY KEY CLUSTERED ([CommercialGLQuoteEndorsementDetailId] ASC, [EndorsementNbr] ASC, [EndorsementId] ASC, [QuoteNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialGLQuoteEndorsementDetail_CommercialGLQuoteEndorsementDetail_01] FOREIGN KEY ([EndorsementNbr], [QuoteNbr], [EndorsementId]) REFERENCES [dbo].[CommercialGLQuoteEndorsement] ([EndorsementNbr], [QuoteNbr], [EndorsementId]),
    CONSTRAINT [FK_CommercialGLQuoteEndorsementDetail_Location_01] FOREIGN KEY ([LocationID]) REFERENCES [dbo].[Location] ([LocationID]),
    CONSTRAINT [FK_CommercialGLQuoteEndorsementDetail_QuoteAdditionalInsured_01] FOREIGN KEY ([QuoteAdditionalInsuredId], [QuoteNbr]) REFERENCES [dbo].[QuoteAdditionalInsured] ([QuoteAdditionalInsuredId], [QuoteNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialGLQuoteEndorsementDetail_01]
    ON [dbo].[CommercialGLQuoteEndorsementDetail]([QuoteNbr] ASC)
    ON [POLICYCI];

