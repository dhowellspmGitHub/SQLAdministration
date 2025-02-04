CREATE TABLE [dbo].[PolicyCashTransaction] (
    [PolicyCashId]              INT            NOT NULL,
    [PolicyId]                  INT            NOT NULL,
    [SequenceNbr]               CHAR (3)       NULL,
    [CurrentRecordInd]          BIT            NOT NULL,
    [PolicyNbr]                 VARCHAR (16)   NOT NULL,
    [LineofBusinessCd]          CHAR (2)       NOT NULL,
    [SublineBusinessTypeCd]     CHAR (1)       NULL,
    [MembershipNbr]             CHAR (10)      NULL,
    [CountyNbr]                 CHAR (3)       NOT NULL,
    [AgencyNbr]                 CHAR (3)       NOT NULL,
    [AccountBillNbr]            CHAR (10)      NOT NULL,
    [AccountingYr]              INT            NOT NULL,
    [AccountingMth]             INT            NOT NULL,
    [ActivityCd]                VARCHAR (60)   NOT NULL,
    [ActivityDt]                DATE           NULL,
    [TransactionDt]             DATE           NULL,
    [TransacationBalanceAmt]    DECIMAL (9, 2) NULL,
    [DueAmt]                    DECIMAL (9, 2) NULL,
    [PreviousDueAmt]            DECIMAL (9, 2) NULL,
    [InstallmentBillAmt]        DECIMAL (9, 2) NULL,
    [PaidAmt]                   DECIMAL (9, 2) NULL,
    [LateChargeAmt]             DECIMAL (9, 2) NULL,
    [LateSurchargeAmt]          DECIMAL (9, 2) NULL,
    [NSFChargeAmt]              DECIMAL (9, 2) NULL,
    [NSFSurchargeAmt]           DECIMAL (9, 2) NULL,
    [ReinstatementChargeAmt]    DECIMAL (9, 2) NULL,
    [ReinstatementSurchargeAmt] DECIMAL (9, 2) NULL,
    [TotalPremiumChargeAmt]     DECIMAL (9, 2) NULL,
    [TotalPremiumSurchargeAmt]  DECIMAL (9, 2) NULL,
    [CommissionAuditInd]        CHAR (1)       NULL,
    [SuppressCommissionInd]     CHAR (1)       NULL,
    [WashAccountInd]            CHAR (1)       NULL,
    [UpdatedTmstmp]             DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]             CHAR (8)       NOT NULL,
    [LastActionCd]              CHAR (1)       NOT NULL,
    [SourceSystemCd]            CHAR (2)       NOT NULL,
    CONSTRAINT [PK_PolicyCashTransaction] PRIMARY KEY NONCLUSTERED ([PolicyCashId] ASC, [PolicyId] ASC) ON [FINANCECD],
    CONSTRAINT [FK_PolicyCashTransaction_Policy_01] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[Policy] ([PolicyId])
) ON [FINANCECD];


GO
CREATE NONCLUSTERED INDEX [IX_PolicyCashTransaction_01]
    ON [dbo].[PolicyCashTransaction]([PolicyNbr] ASC)
    ON [FINANCECI];


GO
CREATE NONCLUSTERED INDEX [IX_PolicyCashTransaction_02]
    ON [dbo].[PolicyCashTransaction]([CurrentRecordInd] ASC)
    ON [FINANCECI];

