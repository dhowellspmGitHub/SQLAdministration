CREATE TABLE [dbo].[AutoQuoteUnitCoverage] (
    [QuoteNbr]               VARCHAR (16)   NOT NULL,
    [QuoteUnitNbr]           INT            NOT NULL,
    [CoverageCd]             CHAR (3)       NOT NULL,
    [SublineBusinessTypeCd]  CHAR (1)       NOT NULL,
    [CoverageDesc]           VARCHAR (250)  NULL,
    [CoverageLimitCd]        CHAR (3)       NULL,
    [CoverageLimitCodeDesc]  VARCHAR (20)   NULL,
    [CoverageLimitAmt]       DECIMAL (9)    NULL,
    [CoverageBasePremiumAmt] DECIMAL (9, 2) NULL,
    [CoveragePremiumAmt]     DECIMAL (9, 2) NULL,
    [CoverageDeductibleCd]   CHAR (3)       NULL,
    [CoverageDeductibleAmt]  DECIMAL (5)    NULL,
    [MinimumPremInd]         BIT            NULL,
    [UpdatedTmstmp]          DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]          CHAR (8)       NOT NULL,
    [LastActionCd]           CHAR (1)       NOT NULL,
    [SourceSystemCd]         CHAR (2)       NOT NULL,
    CONSTRAINT [PK_AutoQuoteUnitCoverage] PRIMARY KEY CLUSTERED ([QuoteNbr] ASC, [QuoteUnitNbr] ASC, [CoverageCd] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AutoQuoteUnitCoverage_AutoQuoteUnit_01] FOREIGN KEY ([QuoteNbr], [QuoteUnitNbr]) REFERENCES [dbo].[AutoQuoteUnit] ([QuoteNbr], [UnitNbr])
) ON [POLICYCD];

