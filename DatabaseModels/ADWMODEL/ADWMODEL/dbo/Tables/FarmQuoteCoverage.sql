CREATE TABLE [dbo].[FarmQuoteCoverage] (
    [QuoteNbr]               VARCHAR (16)   NOT NULL,
    [CoverageCd]             CHAR (3)       NOT NULL,
    [CoverageDesc]           VARCHAR (250)  NOT NULL,
    [CoverageLimitCd]        CHAR (3)       NULL,
    [CoverageLimitAmt]       DECIMAL (9)    NULL,
    [CoveragePremiumAmt]     DECIMAL (9, 2) NULL,
    [SourceSystemCoverageCd] VARCHAR (100)  NULL,
    [ManWorkDaysNbr]         INT            NULL,
    [NamedMedicalPersonsCnt] INT            NULL,
    [UpdatedTmstmp]          DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]          CHAR (8)       NOT NULL,
    [LastActionCd]           CHAR (1)       NOT NULL,
    [SourceSystemCd]         CHAR (2)       NOT NULL,
    CONSTRAINT [PK_FarmQuoteCoverage] PRIMARY KEY CLUSTERED ([CoverageCd] ASC, [QuoteNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FarmQuoteCoverage_FarmQuote_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[FarmQuote] ([QuoteNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_FarmQuoteCoverage_01]
    ON [dbo].[FarmQuoteCoverage]([QuoteNbr] ASC)
    ON [POLICYCI];

