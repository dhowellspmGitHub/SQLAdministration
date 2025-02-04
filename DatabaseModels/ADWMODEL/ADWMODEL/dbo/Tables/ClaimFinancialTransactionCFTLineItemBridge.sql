CREATE TABLE [dbo].[ClaimFinancialTransactionCFTLineItemBridge] (
    [ClaimFinancialTransactionId] INT           NOT NULL,
    [ClaimTransactionDetailId]    INT           NOT NULL,
    [UserUpdatedId]               CHAR (8)      NOT NULL,
    [UpdatedTmstmp]               DATETIME2 (7) NOT NULL,
    [LastActionCd]                CHAR (1)      NOT NULL,
    [SourceSystemCd]              CHAR (2)      NOT NULL,
    CONSTRAINT [PK_ClaimFinanicalTransactionCFTLineItemBridge] PRIMARY KEY NONCLUSTERED ([ClaimFinancialTransactionId] ASC, [ClaimTransactionDetailId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_CFTCFTLineItemBridge_CFT_01] FOREIGN KEY ([ClaimFinancialTransactionId]) REFERENCES [dbo].[ClaimFinancialTransaction] ([ClaimFinancialTransactionId]),
    CONSTRAINT [FK_ClaimFinancialTransactionCFTLineItemBridge_CFTLineItem_01] FOREIGN KEY ([ClaimTransactionDetailId]) REFERENCES [dbo].[ClaimFinancialTransactionLineItem] ([ClaimTransactionDetailId])
) ON [CLAIMSCD];

