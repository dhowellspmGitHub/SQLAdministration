CREATE TABLE [dbo].[PolicyCashCoveragePremium] (
    [PolicyCashCoverageId] INT            NOT NULL,
    [PolicyId]             INT            NOT NULL,
    [PolicyCashId]         INT            NOT NULL,
    [PolicyNbr]            VARCHAR (16)   NOT NULL,
    [UnitNbr]              INT            NOT NULL,
    [AccountingYr]         INT            NOT NULL,
    [AccountingMth]        INT            NOT NULL,
    [CoverageCd]           CHAR (3)       NOT NULL,
    [CoverageLimitCd]      CHAR (3)       NULL,
    [CoverageLimitAmt]     DECIMAL (9)    NULL,
    [CoverageDesc]         VARCHAR (250)  NULL,
    [PremiumGrossAmt]      DECIMAL (9, 2) NULL,
    [PremiumProrateAmt]    DECIMAL (9, 2) NULL,
    [UpdatedTmstmp]        DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]        CHAR (8)       NOT NULL,
    [LastActionCd]         CHAR (1)       NOT NULL,
    [SourceSystemCd]       CHAR (2)       NOT NULL,
    CONSTRAINT [PK_PolicyCashCoveragePremium] PRIMARY KEY NONCLUSTERED ([PolicyCashCoverageId] ASC) ON [FINANCECD],
    CONSTRAINT [FK_PolicyCashCoveragePremium_PolicyCashTransaction_01] FOREIGN KEY ([PolicyCashId], [PolicyId]) REFERENCES [dbo].[PolicyCashTransaction] ([PolicyCashId], [PolicyId]),
    CONSTRAINT [FK_PolicyCashCoveragePremium_PolicyCashUnitTransaction_01] FOREIGN KEY ([UnitNbr], [PolicyId], [PolicyCashId]) REFERENCES [dbo].[PolicyCashUnitTransaction] ([UnitNbr], [PolicyId], [PolicyCashId])
) ON [FINANCECD];


GO
CREATE NONCLUSTERED INDEX [IX_PolicyCashCoveragePremium_01]
    ON [dbo].[PolicyCashCoveragePremium]([PolicyNbr] ASC)
    ON [FINANCECD];

