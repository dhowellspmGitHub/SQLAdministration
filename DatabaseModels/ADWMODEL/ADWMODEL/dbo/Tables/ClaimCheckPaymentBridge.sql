CREATE TABLE [dbo].[ClaimCheckPaymentBridge] (
    [ClaimFinancialTransactionId] INT           NOT NULL,
    [CheckId]                     INT           NOT NULL,
    [UserUpdatedId]               CHAR (8)      NOT NULL,
    [UpdatedTmstmp]               DATETIME2 (7) NOT NULL,
    [LastActionCd]                CHAR (1)      NOT NULL,
    CONSTRAINT [PK_ClaimCheckPaymentBridge] PRIMARY KEY NONCLUSTERED ([ClaimFinancialTransactionId] ASC, [CheckId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_ClaimCheckPaymentBridge_ClaimCheck_01] FOREIGN KEY ([CheckId]) REFERENCES [dbo].[ClaimCheck] ([CheckId]),
    CONSTRAINT [FK_ClaimCheckPaymentBridge_Payment_01] FOREIGN KEY ([ClaimFinancialTransactionId]) REFERENCES [dbo].[Payment] ([ClaimFinancialTransactionId])
) ON [CLAIMSCD];

