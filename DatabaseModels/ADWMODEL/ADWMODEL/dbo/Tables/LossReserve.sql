CREATE TABLE [dbo].[LossReserve] (
    [ClaimFinancialTransactionID] INT             NOT NULL,
    [CurrentReserveBalanceAmt]    DECIMAL (18, 2) NOT NULL,
    [EQReserveInd]                CHAR (1)        NULL,
    [UpdatedTmstmp]               DATETIME2 (7)   NOT NULL,
    [UserUpdatedId]               CHAR (8)        NOT NULL,
    [LastActionCd]                CHAR (1)        NOT NULL,
    [SourceSystemCd]              CHAR (2)        NOT NULL,
    CONSTRAINT [PK_LossReserve] PRIMARY KEY CLUSTERED ([ClaimFinancialTransactionID] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_LossReserve_ClaimFinancialTransaction_01] FOREIGN KEY ([ClaimFinancialTransactionID]) REFERENCES [dbo].[ClaimFinancialTransaction] ([ClaimFinancialTransactionId])
) ON [CLAIMSCD];

