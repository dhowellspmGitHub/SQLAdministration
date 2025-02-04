CREATE TABLE [dbo].[BoatQuoteItem] (
    [ItemNbr]                 CHAR (3)      NOT NULL,
    [UnitNbr]                 INT           NOT NULL,
    [QuoteNbr]                VARCHAR (16)  NOT NULL,
    [ItemDesc]                CHAR (150)    NULL,
    [ItemManufacturingYearDt] CHAR (4)      NULL,
    [ItemMakeDesc]            CHAR (30)     NULL,
    [ItemLengthNbr]           INT           NULL,
    [ItemHPSpeedNbr]          INT           NULL,
    [ItemSerialNbr]           CHAR (20)     NULL,
    [TwinEngineSerialNbr]     CHAR (20)     NULL,
    [TwinEngineInd]           CHAR (1)      NULL,
    [CoverageDesc]            VARCHAR (250) NULL,
    [CoverageLimitAmt]        DECIMAL (9)   NULL,
    [ModelNm]                 VARCHAR (100) NULL,
    [UpdatedTmstmp]           DATETIME2 (7) NOT NULL,
    [UserUpdatedId]           CHAR (8)      NOT NULL,
    [LastActionCd]            CHAR (1)      NOT NULL,
    [SourceSystemCd]          CHAR (2)      NOT NULL,
    CONSTRAINT [PK_BoatQuoteItem] PRIMARY KEY CLUSTERED ([QuoteNbr] ASC, [UnitNbr] ASC, [ItemNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_BoatQuoteItem_BoatQuoteUnit_01] FOREIGN KEY ([QuoteNbr], [UnitNbr]) REFERENCES [dbo].[BoatQuoteUnit] ([QuoteNbr], [UnitNbr])
) ON [POLICYCD];

