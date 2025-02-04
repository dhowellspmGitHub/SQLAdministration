CREATE TABLE [dbo].[PolicyCashUnitTransaction] (
    [PolicyId]       INT           NOT NULL,
    [PolicyCashId]   INT           NOT NULL,
    [UnitNbr]        INT           NOT NULL,
    [PolicyNbr]      VARCHAR (16)  NOT NULL,
    [AccountingYr]   INT           NOT NULL,
    [AccountingMth]  INT           NOT NULL,
    [ActivityCd]     VARCHAR (60)  NOT NULL,
    [ActivityDt]     DATE          NOT NULL,
    [UpdatedTmstmp]  DATETIME2 (7) NOT NULL,
    [UserUpdatedId]  CHAR (8)      NOT NULL,
    [LastActionCd]   CHAR (1)      NOT NULL,
    [SourceSystemCd] CHAR (2)      NOT NULL,
    CONSTRAINT [PK_PolicyCashCoveragePremium_1] PRIMARY KEY CLUSTERED ([UnitNbr] ASC, [PolicyId] ASC, [PolicyCashId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_PolicyCashUnitTransaction_PolicyCashTransaction_01] FOREIGN KEY ([PolicyCashId], [PolicyId]) REFERENCES [dbo].[PolicyCashTransaction] ([PolicyCashId], [PolicyId])
) ON [POLICYCD];

