CREATE TABLE [dbo].[FireUnitTax] (
    [PolicyId]                      INT            NOT NULL,
    [UnitNbr]                       INT            NOT NULL,
    [PolicyNbr]                     VARCHAR (16)   NOT NULL,
    [TaxCd]                         CHAR (4)       NULL,
    [TaxExemptInd]                  CHAR (1)       NULL,
    [TaxJurisdictionNm]             CHAR (40)      NULL,
    [TaxOverrideInd]                CHAR (1)       NULL,
    [TaxPremiumAmt]                 DECIMAL (9, 2) NULL,
    [EQTaxPremiumAmt]               DECIMAL (9, 2) NULL,
    [TaxRateFctr]                   DECIMAL (9, 4) NULL,
    [MunTaxRateFctr]                DECIMAL (9, 4) NULL,
    [MunTaxPremiumAmt]              DECIMAL (9, 2) NULL,
    [EQMunicipalTaxPremiumAmt]      DECIMAL (9, 2) NULL,
    [TaxTypeCd]                     CHAR (3)       NULL,
    [CountyTaxRateFctr]             DECIMAL (9, 4) NULL,
    [CountyTaxPremiumAmt]           DECIMAL (9, 2) NULL,
    [EQCountyTaxPremiumAmt]         DECIMAL (9, 2) NULL,
    [StateSurchargeTaxPremiumAmt]   DECIMAL (9, 2) NULL,
    [EQStateSurchargeTaxPremiumAmt] DECIMAL (9, 2) NULL,
    [EQProratedMunicipalTaxAmt]     DECIMAL (9, 2) NULL,
    [EQProratedCountyTaxAmt]        DECIMAL (9, 2) NULL,
    [EQProratedSurchargeAmt]        DECIMAL (9, 2) NULL,
    [EQSurplusTaxAmt]               DECIMAL (9, 2) NULL,
    [UpdatedTmstmp]                 DATETIME2 (7)  NOT NULL,
    [ProratedEQSurplusTaxAmt]       DECIMAL (9, 2) NULL,
    [UserUpdatedId]                 CHAR (8)       NOT NULL,
    [LastActionCd]                  CHAR (1)       NOT NULL,
    [SourceSystemCd]                CHAR (2)       NOT NULL,
    CONSTRAINT [PK_FireUnitTax] PRIMARY KEY CLUSTERED ([UnitNbr] ASC, [PolicyId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FireUnitTax_FireUnit_01] FOREIGN KEY ([PolicyId], [UnitNbr]) REFERENCES [dbo].[FireUnit] ([PolicyId], [UnitNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_FireUnitTax_01]
    ON [dbo].[FireUnitTax]([PolicyId] ASC)
    ON [POLICYCI];

