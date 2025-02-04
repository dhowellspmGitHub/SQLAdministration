CREATE TABLE [dbo].[PolicyCashTaxPremium] (
    [PolicyCashTaxId]   INT            NOT NULL,
    [PolicyId]          INT            NOT NULL,
    [PolicyCashId]      INT            NOT NULL,
    [PolicyNbr]         VARCHAR (16)   NOT NULL,
    [UnitNbr]           INT            NOT NULL,
    [AccountingYr]      INT            NOT NULL,
    [AccountingMth]     INT            NOT NULL,
    [TaxTypeCd]         CHAR (3)       NOT NULL,
    [TaxCd]             CHAR (4)       NULL,
    [PremiumProrateAmt] DECIMAL (9, 2) NULL,
    [PremiumGrossAmt]   DECIMAL (9, 2) NULL,
    [UpdatedTmstmp]     DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]     CHAR (8)       NOT NULL,
    [LastActionCd]      CHAR (1)       NOT NULL,
    [SourceSystemCd]    CHAR (2)       NOT NULL,
    CONSTRAINT [PK_PolicyCashTaxPremium] PRIMARY KEY NONCLUSTERED ([PolicyCashTaxId] ASC) ON [FINANCECD],
    CONSTRAINT [FK_PolicyCashTaxPremium_PolicyCashTransaction_01] FOREIGN KEY ([PolicyCashId], [PolicyId]) REFERENCES [dbo].[PolicyCashTransaction] ([PolicyCashId], [PolicyId]),
    CONSTRAINT [FK_PolicyCashTaxPremium_PolicyCashUnitTransaction_01] FOREIGN KEY ([UnitNbr], [PolicyId], [PolicyCashId]) REFERENCES [dbo].[PolicyCashUnitTransaction] ([UnitNbr], [PolicyId], [PolicyCashId])
) ON [FINANCECD];


GO
CREATE NONCLUSTERED INDEX [IX_PolicyCashTaxPremium_01]
    ON [dbo].[PolicyCashTaxPremium]([PolicyNbr] ASC)
    ON [FINANCECD];

