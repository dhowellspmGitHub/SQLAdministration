CREATE TABLE [dbo].[FireQuoteUnitCoverageItem] (
    [QuoteNbr]           VARCHAR (16)   NOT NULL,
    [UnitNbr]            INT            NOT NULL,
    [CoverageCd]         CHAR (3)       NOT NULL,
    [CoverageItemCd]     CHAR (3)       NOT NULL,
    [CoverageLimitAmt]   DECIMAL (9)    NULL,
    [CoveragePremiumAmt] DECIMAL (9, 2) NULL,
    [UserUpdatedId]      CHAR (8)       NOT NULL,
    [UpdatedTmstmp]      DATETIME2 (7)  NOT NULL,
    [UserCreatedId]      CHAR (8)       NOT NULL,
    [CreatedTmstmp]      DATETIME       NOT NULL,
    [LastActionCd]       CHAR (1)       NOT NULL,
    [SourceSystemCd]     CHAR (2)       NOT NULL,
    CONSTRAINT [PK_FireQuoteUnitCoverageItem] PRIMARY KEY CLUSTERED ([UnitNbr] ASC, [CoverageCd] ASC, [QuoteNbr] ASC, [CoverageItemCd] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FireQuoteUnitCoverageItem_FireQuoteUnitCoverage_01] FOREIGN KEY ([UnitNbr], [CoverageCd], [QuoteNbr]) REFERENCES [dbo].[FireQuoteUnitCoverage] ([UnitNbr], [CoverageCd], [QuoteNbr])
) ON [POLICYCD];

