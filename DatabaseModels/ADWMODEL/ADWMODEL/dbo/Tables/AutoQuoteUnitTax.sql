CREATE TABLE [dbo].[AutoQuoteUnitTax] (
    [QuoteNbr]              VARCHAR (16)   NOT NULL,
    [QuoteUnitNbr]          INT            NOT NULL,
    [TaxTypeCd]             CHAR (3)       NOT NULL,
    [SublineBusinessTypeCd] CHAR (1)       NOT NULL,
    [TaxCd]                 CHAR (4)       NULL,
    [TaxExemptInd]          CHAR (1)       NULL,
    [TaxJurisdictionNm]     CHAR (40)      NULL,
    [TaxOverrideInd]        CHAR (1)       NULL,
    [TaxPremiumAmt]         DECIMAL (9, 2) NULL,
    [TaxRateFctr]           DECIMAL (9, 4) NULL,
    [UpdatedTmstmp]         DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]         CHAR (8)       NOT NULL,
    [LastActionCd]          CHAR (1)       NOT NULL,
    [SourceSystemCd]        CHAR (2)       NOT NULL,
    CONSTRAINT [PK_AutoQuoteUnitTax] PRIMARY KEY CLUSTERED ([QuoteNbr] ASC, [QuoteUnitNbr] ASC, [TaxTypeCd] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AutoQuoteUnitTax_AutoQuoteUnit_01] FOREIGN KEY ([QuoteNbr], [QuoteUnitNbr]) REFERENCES [dbo].[AutoQuoteUnit] ([QuoteNbr], [UnitNbr])
) ON [POLICYCD];

