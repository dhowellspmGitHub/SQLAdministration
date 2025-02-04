CREATE TABLE [dbo].[UmbrellaPolicyTax] (
    [TaxTypeCd]              CHAR (3)       NOT NULL,
    [PolicyId]               INT            NOT NULL,
    [PolicyNbr]              VARCHAR (16)   NOT NULL,
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
    CONSTRAINT [PK_UmbrellaPolicyTax] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [TaxTypeCd] ASC) ON [POLICYCD],
    CONSTRAINT [FK_UmbrellaPolicyTax_UmbrellaPolicy_01] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[UmbrellaPolicy] ([PolicyId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_UmbrellaPolicyTax_01]
    ON [dbo].[UmbrellaPolicyTax]([PolicyId] ASC)
    ON [POLICYCI];

