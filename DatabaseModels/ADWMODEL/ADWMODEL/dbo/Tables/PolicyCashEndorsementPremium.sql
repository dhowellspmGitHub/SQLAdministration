CREATE TABLE [dbo].[PolicyCashEndorsementPremium] (
    [PolicyCashEndorsementId] INT            NOT NULL,
    [PolicyId]                INT            NOT NULL,
    [PolicyCashId]            INT            NOT NULL,
    [PolicyNbr]               VARCHAR (16)   NOT NULL,
    [UnitNbr]                 INT            NOT NULL,
    [AccountingYr]            INT            NOT NULL,
    [AccountingMth]           INT            NOT NULL,
    [EndorsementNbr]          CHAR (10)      NOT NULL,
    [EndorsementDesc]         VARCHAR (100)  NULL,
    [PremiumGrossAmt]         DECIMAL (9, 2) NULL,
    [PremiumProrateAmt]       DECIMAL (9, 2) NULL,
    [UpdatedTmstmp]           DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]           CHAR (8)       NOT NULL,
    [LastActionCd]            CHAR (1)       NOT NULL,
    [SourceSystemCd]          CHAR (2)       NOT NULL,
    CONSTRAINT [PK_PolicyCashEndorsementPremium] PRIMARY KEY NONCLUSTERED ([PolicyCashEndorsementId] ASC) ON [FINANCECD],
    CONSTRAINT [FK_PolicyCashEndorsementPremium_PolicyCashTransaction_01] FOREIGN KEY ([PolicyCashId], [PolicyId]) REFERENCES [dbo].[PolicyCashTransaction] ([PolicyCashId], [PolicyId]),
    CONSTRAINT [FK_PolicyCashEndorsementPremium_PolicyCashUnitTransaction_01] FOREIGN KEY ([UnitNbr], [PolicyId], [PolicyCashId]) REFERENCES [dbo].[PolicyCashUnitTransaction] ([UnitNbr], [PolicyId], [PolicyCashId])
) ON [FINANCECD];


GO
CREATE NONCLUSTERED INDEX [IX_PolicyCashEndorsementPremium_01]
    ON [dbo].[PolicyCashEndorsementPremium]([PolicyNbr] ASC)
    ON [FINANCECD];

