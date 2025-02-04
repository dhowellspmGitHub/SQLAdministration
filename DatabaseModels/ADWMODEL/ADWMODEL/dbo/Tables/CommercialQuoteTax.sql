CREATE TABLE [dbo].[CommercialQuoteTax] (
    [QuoteNbr]          VARCHAR (16)   NOT NULL,
    [TaxTypeCd]         CHAR (3)       NOT NULL,
    [TaxCd]             CHAR (4)       NULL,
    [TaxExemptInd]      CHAR (1)       NULL,
    [TaxJurisdictionNm] CHAR (40)      NULL,
    [TaxOverrideInd]    CHAR (1)       NULL,
    [TaxPremiumAmt]     DECIMAL (9, 2) NULL,
    [TaxRateFctr]       DECIMAL (9, 4) NULL,
    [UpdatedTmstmp]     DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]     CHAR (8)       NOT NULL,
    [LastActionCd]      CHAR (1)       NOT NULL,
    [SourceSystemCd]    CHAR (2)       NOT NULL,
    CONSTRAINT [PK_CommercialQuoteTax] PRIMARY KEY CLUSTERED ([TaxTypeCd] ASC, [QuoteNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialQuoteTax_CommercialQuote_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[CommercialQuote] ([QuoteNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialQuoteTax_01]
    ON [dbo].[CommercialQuoteTax]([QuoteNbr] ASC)
    ON [POLICYCI];

