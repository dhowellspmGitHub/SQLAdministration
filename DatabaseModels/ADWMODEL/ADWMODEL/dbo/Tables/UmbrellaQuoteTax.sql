CREATE TABLE [dbo].[UmbrellaQuoteTax] (
    [QuoteNbr]               VARCHAR (16)   NOT NULL,
    [TaxTypeCd]              CHAR (3)       NOT NULL,
    [TaxCd]                  CHAR (4)       NULL,
    [TaxExemptInd]           CHAR (1)       NULL,
    [TaxJurisdictionNm]      CHAR (40)      NULL,
    [TaxOverrideInd]         CHAR (1)       NULL,
    [TaxPremiumAmt]          DECIMAL (9, 2) NULL,
    [TaxRateFctr]            DECIMAL (9, 4) NULL,
    [CountyTaxCd]            CHAR (4)       NULL,
    [CountyTaxPremiumAmt]    DECIMAL (9, 2) NULL,
    [CountyTaxRateFctr]      DECIMAL (9, 4) NULL,
    [MunicipalTaxCd]         CHAR (4)       NULL,
    [MunicipalTaxPremiumAmt] DECIMAL (9, 2) NULL,
    [MunicipalTaxRateFctr]   DECIMAL (9, 4) NULL,
    [SurchargeTaxAmt]        DECIMAL (9, 2) NULL,
    [UpdatedTmstmp]          DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]          CHAR (8)       NOT NULL,
    [LastActionCd]           CHAR (1)       NOT NULL,
    [SourceSystemCd]         CHAR (2)       NOT NULL,
    CONSTRAINT [PK_UmbrellaQuoteTax] PRIMARY KEY CLUSTERED ([TaxTypeCd] ASC, [QuoteNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_UmbrellaQuoteTax_UmbrellaQuote_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[UmbrellaQuote] ([QuoteNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_UmbrellaQuoteTax_01]
    ON [dbo].[UmbrellaQuoteTax]([QuoteNbr] ASC)
    ON [POLICYCI];

