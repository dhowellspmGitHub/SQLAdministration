CREATE TABLE [dbo].[UmbrellaQuoteCoverage] (
    [QuoteNbr]              VARCHAR (16)   NOT NULL,
    [CoverageCd]            CHAR (3)       NOT NULL,
    [CoverageDeductibleAmt] DECIMAL (5)    NULL,
    [CoverageDeductibleCd]  CHAR (3)       NULL,
    [CoverageDesc]          VARCHAR (250)  NULL,
    [CoverageLimitAmt]      DECIMAL (9)    NULL,
    [CoverageLimitCd]       CHAR (3)       NULL,
    [CoverageLimitCodeDesc] VARCHAR (20)   NULL,
    [CoveragePremiumAmt]    DECIMAL (9, 2) NULL,
    [CreatedTmstmp]         DATETIME       NOT NULL,
    [UserCreatedId]         CHAR (8)       NOT NULL,
    [UpdatedTmstmp]         DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]         CHAR (8)       NOT NULL,
    [LastActionCd]          CHAR (1)       NOT NULL,
    [SourceSystemCd]        CHAR (2)       NOT NULL,
    CONSTRAINT [PK_UmbrellaQuoteCoverage] PRIMARY KEY CLUSTERED ([CoverageCd] ASC, [QuoteNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_UmbrellaQuoteCoverage_UmbrellaQuote_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[UmbrellaQuote] ([QuoteNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_UmbrellaQuoteCoverage_01]
    ON [dbo].[UmbrellaQuoteCoverage]([QuoteNbr] ASC)
    ON [POLICYCI];

