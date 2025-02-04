CREATE TABLE [dbo].[ClaimFinancialTransactionLineItem] (
    [ClaimTransactionDetailId] INT             NOT NULL,
    [ClaimTransactionAmt]      DECIMAL (18, 2) NULL,
    [RetiredInd]               CHAR (1)        NOT NULL,
    [UpdatedTmstmp]            DATETIME2 (7)   NOT NULL,
    [UserUpdatedId]            CHAR (8)        NOT NULL,
    [LastActionCd]             CHAR (1)        NOT NULL,
    [SourceSystemCd]           CHAR (2)        NOT NULL,
    [SourceSystemId]           INT             NOT NULL,
    [ClaimUserCreateTime]      DATETIME2 (7)   NOT NULL,
    [ClaimUserCreatedId]       CHAR (8)        NOT NULL,
    [ClaimUserUpdatedId]       CHAR (8)        NOT NULL,
    [ClaimUpdatedTmstmp]       DATETIME2 (7)   NOT NULL,
    [CurrentRecordInd]         BIT             NOT NULL,
    [LineCategoryId]           INT             NULL,
    CONSTRAINT [PK_ClaimFinancialTransactionLineItem] PRIMARY KEY CLUSTERED ([ClaimTransactionDetailId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_ClaimFinancialTransactionLineItem_ClaimCodeLookup_01] FOREIGN KEY ([LineCategoryId]) REFERENCES [dbo].[ClaimCodeLookup] ([ClaimCodeLookupId])
) ON [CLAIMSCD];

