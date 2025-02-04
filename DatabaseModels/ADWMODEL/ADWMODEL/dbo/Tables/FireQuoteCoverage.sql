﻿CREATE TABLE [dbo].[FireQuoteCoverage] (
    [QuoteNbr]                 VARCHAR (16)   NOT NULL,
    [CoverageCd]               CHAR (3)       NOT NULL,
    [CoverageDesc]             VARCHAR (250)  NOT NULL,
    [CoverageLimitCd]          CHAR (3)       NULL,
    [CoverageLimitCodeDesc]    VARCHAR (20)   NULL,
    [CoverageLimitAmt]         DECIMAL (9)    NULL,
    [CoveragePremiumAmt]       DECIMAL (9, 2) NULL,
    [CoverageDeductibleTypeCd] CHAR (3)       NULL,
    [CoverageDeductibleCd]     CHAR (3)       NULL,
    [CoverageDeductibleAmt]    DECIMAL (5)    NULL,
    [CoverageDedWindHailAmt]   DECIMAL (9)    NULL,
    [SourceSystemCoverageCd]   VARCHAR (100)  NULL,
    [UpdatedTmstmp]            DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]            CHAR (8)       NOT NULL,
    [LastActionCd]             CHAR (1)       NOT NULL,
    [SourceSystemCd]           CHAR (2)       NOT NULL,
    CONSTRAINT [PK_FireQuoteCoverage] PRIMARY KEY NONCLUSTERED ([CoverageCd] ASC, [QuoteNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FireQuoteCoverage_FireQuote_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[FireQuote] ([QuoteNbr])
) ON [POLICYCD];

