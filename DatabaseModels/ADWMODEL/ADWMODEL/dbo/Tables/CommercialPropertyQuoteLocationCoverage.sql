CREATE TABLE [dbo].[CommercialPropertyQuoteLocationCoverage] (
    [QuoteNbr]           VARCHAR (16)   NOT NULL,
    [LocationID]         BIGINT         NOT NULL,
    [CoverageCd]         CHAR (3)       NOT NULL,
    [CoverageLimitAmt]   DECIMAL (9)    NULL,
    [CoveragePremiumAmt] DECIMAL (9, 2) NOT NULL,
    [CoverageDesc]       VARCHAR (250)  NOT NULL,
    [CreatedTmstmp]      DATETIME       NOT NULL,
    [UserCreatedId]      CHAR (8)       NOT NULL,
    [UpdatedTmstmp]      DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]      CHAR (8)       NOT NULL,
    [LastActionCd]       CHAR (1)       NOT NULL,
    [SourceSystemCd]     CHAR (2)       NOT NULL,
    CONSTRAINT [PK_CommercialPropertyQuoteLocationCoverage] PRIMARY KEY CLUSTERED ([CoverageCd] ASC, [LocationID] ASC, [QuoteNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialPropertyQuoteLocationCoverage_CommercialQuote_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[CommercialQuote] ([QuoteNbr]),
    CONSTRAINT [FK_CommercialPropertyQuoteLocationCoverage_QuoteLocationDetail_01] FOREIGN KEY ([QuoteNbr], [LocationID]) REFERENCES [dbo].[QuoteLocationDetail] ([QuoteNbr], [LocationID])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialPropertyQuoteLocationCoverage_01]
    ON [dbo].[CommercialPropertyQuoteLocationCoverage]([QuoteNbr] ASC)
    ON [POLICYCI];

