CREATE TABLE [dbo].[MobileHomeQuoteUnitCoverage] (
    [CoverageCd]             CHAR (3)       NOT NULL,
    [UnitNbr]                INT            NOT NULL,
    [QuoteNbr]               VARCHAR (16)   NOT NULL,
    [CoverageDesc]           VARCHAR (250)  NOT NULL,
    [CoverageLimitAmt]       DECIMAL (9)    NULL,
    [CoveragePremiumAmt]     DECIMAL (9, 2) NULL,
    [CoverageDeductibleAmt]  DECIMAL (5)    NULL,
    [CoverageDedWindHailAmt] DECIMAL (9)    NULL,
    [CoverageOptionDesc]     VARCHAR (255)  NULL,
    [SourceSystemCoverageCd] VARCHAR (100)  NULL,
    [UpdatedTmstmp]          DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]          CHAR (8)       NOT NULL,
    [LastActionCd]           CHAR (1)       NOT NULL,
    [SourceSystemCd]         CHAR (2)       NOT NULL,
    CONSTRAINT [PK_MobileHomeQuoteUnitCoverage] PRIMARY KEY CLUSTERED ([QuoteNbr] ASC, [UnitNbr] ASC, [CoverageCd] ASC) ON [POLICYCD],
    CONSTRAINT [FK_MobileHomeUnitCoverage_MobileHomeQuoteUnit_01] FOREIGN KEY ([QuoteNbr], [UnitNbr]) REFERENCES [dbo].[MobileHomeQuoteUnit] ([QuoteNbr], [UnitNbr])
) ON [POLICYCD];

