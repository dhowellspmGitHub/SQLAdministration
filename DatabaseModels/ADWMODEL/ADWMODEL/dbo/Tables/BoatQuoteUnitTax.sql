CREATE TABLE [dbo].[BoatQuoteUnitTax] (
    [UnitNbr]                     INT            NOT NULL,
    [QuoteNbr]                    VARCHAR (16)   NOT NULL,
    [TaxCd]                       CHAR (4)       NULL,
    [TaxTypeCd]                   CHAR (3)       NULL,
    [TaxExemptInd]                CHAR (1)       NULL,
    [TaxJurisdictionNm]           CHAR (40)      NULL,
    [TaxPremiumAmt]               DECIMAL (9, 2) NULL,
    [TaxRateFctr]                 DECIMAL (9, 4) NULL,
    [MunTaxRateFctr]              DECIMAL (9, 4) NULL,
    [MunTaxPremiumAmt]            DECIMAL (9, 2) NULL,
    [CountyTaxRateFctr]           DECIMAL (9, 4) NULL,
    [CountyTaxPremiumAmt]         DECIMAL (9, 2) NULL,
    [UpdatedTmstmp]               DATETIME2 (7)  NOT NULL,
    [StateSurchargeTaxPremiumAmt] DECIMAL (9, 2) NULL,
    [UserUpdatedId]               CHAR (8)       NOT NULL,
    [LastActionCd]                CHAR (1)       NOT NULL,
    [SourceSystemCd]              CHAR (2)       NOT NULL,
    CONSTRAINT [PK_BoatQuoteUnitTax] PRIMARY KEY NONCLUSTERED ([QuoteNbr] ASC, [UnitNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_BoatQuoteUnitTax_BoatQuoteUnit_01] FOREIGN KEY ([QuoteNbr], [UnitNbr]) REFERENCES [dbo].[BoatQuoteUnit] ([QuoteNbr], [UnitNbr])
) ON [POLICYCD];

