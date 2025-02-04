CREATE TABLE [dbo].[CommercialQuoteCrimeCoverage] (
    [QuoteNbr]                VARCHAR (16)    NOT NULL,
    [CoverageCd]              CHAR (3)        NOT NULL,
    [EndorsementId]           INT             NULL,
    [EndorsementNbr]          CHAR (10)       NULL,
    [CoverageLimitAmt]        DECIMAL (9)     NULL,
    [CoveragePremiumAmt]      DECIMAL (9, 2)  NULL,
    [CoverageDeductibleAmt]   DECIMAL (5)     NULL,
    [SellingPriceAmt]         DECIMAL (9)     NULL,
    [SourceSystemCoverageCd]  VARCHAR (100)   NULL,
    [SellingPriceIncludedInd] CHAR (1)        NULL,
    [DeductibleAmt]           DECIMAL (18, 2) NULL,
    [CreatedTmstmp]           DATETIME        NOT NULL,
    [UserCreatedId]           CHAR (8)        NOT NULL,
    [UpdatedTmstmp]           DATETIME2 (7)   NOT NULL,
    [UserUpdatedId]           CHAR (8)        NOT NULL,
    [LastActionCd]            CHAR (1)        NOT NULL,
    [SourceSystemCd]          CHAR (2)        NOT NULL,
    CONSTRAINT [PK_CommercialQuoteCrimeCoverage] PRIMARY KEY CLUSTERED ([CoverageCd] ASC, [QuoteNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialQuoteCrimeCoverage_CommercialQuote_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[CommercialQuote] ([QuoteNbr]),
    CONSTRAINT [FK_CommercialQuoteCrimeCoverage_Endorsements_01] FOREIGN KEY ([EndorsementId]) REFERENCES [dbo].[Endorsements] ([EndorsementId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialQuoteCrimeCoverage_01]
    ON [dbo].[CommercialQuoteCrimeCoverage]([QuoteNbr] ASC)
    ON [POLICYCI];

