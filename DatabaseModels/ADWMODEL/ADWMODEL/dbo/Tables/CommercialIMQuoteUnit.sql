CREATE TABLE [dbo].[CommercialIMQuoteUnit] (
    [QuoteNbr]             VARCHAR (16)   NOT NULL,
    [IMPartCoverageTypeCd] VARCHAR (50)   NOT NULL,
    [UnitNbr]              INT            NOT NULL,
    [LocationID]           BIGINT         NULL,
    [ProgramCd]            CHAR (1)       NULL,
    [CashUnitNbr]          CHAR (3)       NULL,
    [PartDesc]             VARCHAR (50)   NULL,
    [ItemBasicDesc]        VARCHAR (250)  NULL,
    [InlandMarineClassCd]  CHAR (7)       NOT NULL,
    [ConstructionTypeDesc] CHAR (50)      NOT NULL,
    [LimitAmt]             DECIMAL (9)    NULL,
    [EquipmentIDNbr]       CHAR (20)      NOT NULL,
    [ManufacturerNm]       VARCHAR (50)   NULL,
    [ModelNm]              VARCHAR (100)  NULL,
    [ManufacturingYearDt]  CHAR (4)       NOT NULL,
    [RiskTypeCd]           CHAR (10)      NULL,
    [MilesDrivenNbr]       DECIMAL (5)    NULL,
    [LocationTypeCd]       VARCHAR (50)   NULL,
    [PurchaseYearDt]       CHAR (4)       NULL,
    [PremiumAmt]           DECIMAL (9, 2) NOT NULL,
    [TaxAmt]               DECIMAL (9, 2) NULL,
    [SurchargeTaxAmt]      DECIMAL (9, 2) NULL,
    [ValuationTypeDesc]    VARCHAR (200)  NULL,
    [LocationDesc]         VARCHAR (255)  NULL,
    [CreatedTmstmp]        DATETIME       NOT NULL,
    [UserCreatedId]        CHAR (8)       NOT NULL,
    [UpdatedTmstmp]        DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]        CHAR (8)       NOT NULL,
    [LastActionCd]         CHAR (1)       NOT NULL,
    [SourceSystemCd]       CHAR (2)       NOT NULL,
    CONSTRAINT [PK_CommercialIMQuoteUnit] PRIMARY KEY CLUSTERED ([IMPartCoverageTypeCd] ASC, [UnitNbr] ASC, [QuoteNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialIMQuoteUnit_CommercialIMQuote_01] FOREIGN KEY ([IMPartCoverageTypeCd], [QuoteNbr]) REFERENCES [dbo].[CommercialIMQuote] ([IMPartCoverageTypeCd], [QuoteNbr]),
    CONSTRAINT [FK_CommercialIMQuoteUnit_Location_01] FOREIGN KEY ([LocationID]) REFERENCES [dbo].[Location] ([LocationID])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialIMQuoteUnit_01]
    ON [dbo].[CommercialIMQuoteUnit]([QuoteNbr] ASC)
    ON [POLICYCI];

