CREATE TABLE [dbo].[FarmQuoteUnitCoverage] (
    [QuoteNbr]               VARCHAR (16)   NOT NULL,
    [UnitNbr]                INT            NOT NULL,
    [UnitTypeCd]             CHAR (1)       NOT NULL,
    [CoverageCd]             CHAR (3)       NOT NULL,
    [CoverageDesc]           VARCHAR (250)  NULL,
    [CoverageLimitCd]        CHAR (3)       NULL,
    [CoverageLimitCodeDesc]  VARCHAR (20)   NULL,
    [CoverageLimitAmt]       DECIMAL (9)    NULL,
    [CoveragePremiumAmt]     DECIMAL (9, 2) NULL,
    [MainDwellingPct]        DECIMAL (5, 2) NULL,
    [ValuationMethodCd]      CHAR (1)       NULL,
    [SourceSystemCoverageCd] VARCHAR (100)  NULL,
    [CreatedTmstmp]          DATETIME       NOT NULL,
    [UserCreatedId]          CHAR (8)       NOT NULL,
    [UpdatedTmstmp]          DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]          CHAR (8)       NOT NULL,
    [LastActionCd]           CHAR (1)       NOT NULL,
    [SourceSystemCd]         CHAR (2)       NOT NULL,
    CONSTRAINT [PK_FarmQuoteUnitCoverage] PRIMARY KEY CLUSTERED ([CoverageCd] ASC, [UnitNbr] ASC, [UnitTypeCd] ASC, [QuoteNbr] ASC),
    CONSTRAINT [FK_FarmUnitQuoteCoverage_FarmUnitQuote_01] FOREIGN KEY ([UnitNbr], [UnitTypeCd], [QuoteNbr]) REFERENCES [dbo].[FarmQuoteUnit] ([UnitNbr], [UnitTypeCd], [QuoteNbr])
);

