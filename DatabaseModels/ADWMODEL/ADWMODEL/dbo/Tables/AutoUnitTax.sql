CREATE TABLE [dbo].[AutoUnitTax] (
    [PolicyId]              INT            NOT NULL,
    [UnitNbr]               INT            NOT NULL,
    [TaxTypeCd]             CHAR (3)       NOT NULL,
    [PolicyNbr]             VARCHAR (16)   NOT NULL,
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
    CONSTRAINT [PK_AutoUnitTax] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [UnitNbr] ASC, [TaxTypeCd] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AutoUnitTax_AutoUnit_01] FOREIGN KEY ([PolicyId], [UnitNbr]) REFERENCES [dbo].[AutoUnit] ([PolicyId], [UnitNbr])
) ON [POLICYCD];

