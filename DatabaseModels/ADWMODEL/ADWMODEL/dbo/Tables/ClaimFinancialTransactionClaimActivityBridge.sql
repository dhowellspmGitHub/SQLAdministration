CREATE TABLE [dbo].[ClaimFinancialTransactionClaimActivityBridge] (
    [ClaimFinancialTransactionId] INT           NULL,
    [ClaimActivityId]             INT           NULL,
    [UserUpdatedId]               CHAR (8)      NOT NULL,
    [UpdatedTmstmp]               DATETIME2 (7) NOT NULL,
    [SourceSystemCd]              CHAR (2)      NOT NULL,
    [LastActionCd]                CHAR (1)      NOT NULL,
    CONSTRAINT [FK_ClaimFinancialTransactionClaimActivityBridge_ClaimActivity_01] FOREIGN KEY ([ClaimActivityId]) REFERENCES [dbo].[ClaimActivity] ([ClaimActivityId]),
    CONSTRAINT [FK_ClaimFinancialTransactionClaimActivityBridge_ClaimFinancialTransaction_01] FOREIGN KEY ([ClaimFinancialTransactionId]) REFERENCES [dbo].[ClaimFinancialTransaction] ([ClaimFinancialTransactionId])
) ON [CLAIMSCD];

