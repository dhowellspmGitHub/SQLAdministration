CREATE TABLE [dbo].[BoatUnitTax] (
    [PolicyId]                    INT            NOT NULL,
    [UnitNbr]                     INT            NOT NULL,
    [PolicyNbr]                   VARCHAR (16)   NOT NULL,
    [TaxCd]                       CHAR (4)       NULL,
    [TaxTypeCd]                   CHAR (3)       NULL,
    [TaxExemptInd]                CHAR (1)       NULL,
    [TaxJurisdictionNm]           CHAR (40)      NULL,
    [TaxOverrideInd]              CHAR (1)       NULL,
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
    CONSTRAINT [PK_BoatUnitTax] PRIMARY KEY NONCLUSTERED ([PolicyId] ASC, [UnitNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_BoatUnitTax_BoatUnit_01] FOREIGN KEY ([PolicyId], [UnitNbr]) REFERENCES [dbo].[BoatUnit] ([PolicyId], [UnitNbr])
) ON [POLICYCD];

