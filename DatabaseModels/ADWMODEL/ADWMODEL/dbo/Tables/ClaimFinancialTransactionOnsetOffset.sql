CREATE TABLE [dbo].[ClaimFinancialTransactionOnsetOffset] (
    [ClaimFinancialTransactionOnsetOffsetID] INT           NOT NULL,
    [ClaimFinancialTransactionId]            INT           NOT NULL,
    [OffSetId]                               INT           NOT NULL,
    [OnSetId]                                INT           NULL,
    [OnSetTransactionSourceSystemID]         INT           NULL,
    [OffsetSourceSystemId]                   INT           NOT NULL,
    [OnsetSourceSystemId]                    INT           NOT NULL,
    [UserUpdatedId]                          CHAR (8)      NOT NULL,
    [LastActionCd]                           CHAR (1)      NOT NULL,
    [SourceSystemCd]                         CHAR (2)      NOT NULL,
    [CurrentRecordInd]                       BIT           NOT NULL,
    [UpdatedTmstmp]                          DATETIME2 (7) NOT NULL,
    CONSTRAINT [PK_ClaimFinancialTransactionOnsetOffset] PRIMARY KEY CLUSTERED ([ClaimFinancialTransactionOnsetOffsetID] ASC, [ClaimFinancialTransactionId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_ClaimFinancialTransactionOnsetOffset_ClaimFinancialTransaction_01] FOREIGN KEY ([ClaimFinancialTransactionId]) REFERENCES [dbo].[ClaimFinancialTransaction] ([ClaimFinancialTransactionId]),
    CONSTRAINT [FK_ClaimFinancialTransactionOnsetOffset_ClaimFinancialTransaction_02] FOREIGN KEY ([OffSetId]) REFERENCES [dbo].[ClaimFinancialTransaction] ([ClaimFinancialTransactionId]),
    CONSTRAINT [FK_ClaimFinancialTransactionOnsetOffset_ClaimFinancialTransaction_03] FOREIGN KEY ([OnSetId]) REFERENCES [dbo].[ClaimFinancialTransaction] ([ClaimFinancialTransactionId])
) ON [CLAIMSCD];

