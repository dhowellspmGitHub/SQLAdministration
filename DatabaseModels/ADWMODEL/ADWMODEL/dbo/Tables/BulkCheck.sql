CREATE TABLE [dbo].[BulkCheck] (
    [BulkCheckId]         INT             NOT NULL,
    [TransactionStatusId] INT             NOT NULL,
    [PartyId]             INT             NOT NULL,
    [CheckNbr]            CHAR (10)       NULL,
    [ServiceDt]           DATE            NULL,
    [ScheduledSendDt]     DATE            NULL,
    [BulkCheckAmt]        DECIMAL (18, 2) NULL,
    [UpdatedTmstmp]       DATETIME2 (7)   NOT NULL,
    [UserUpdatedId]       CHAR (8)        NOT NULL,
    [LastActionCd]        CHAR (1)        NOT NULL,
    [SourceSystemCd]      CHAR (2)        NOT NULL,
    [ClaimUserCreateTime] DATETIME2 (7)   NOT NULL,
    [ClaimUserCreatedId]  CHAR (8)        NOT NULL,
    [ClaimUserUpdatedId]  CHAR (8)        NOT NULL,
    [ClaimUpdatedTmstmp]  DATETIME2 (7)   NOT NULL,
    [CurrentRecordInd]    BIT             NOT NULL,
    [RetiredInd]          CHAR (1)        NOT NULL,
    [SourceSystemId]      INT             NOT NULL,
    CONSTRAINT [PK_BulkCheck] PRIMARY KEY CLUSTERED ([BulkCheckId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_BulkCheck_ClaimCodeLookup_01] FOREIGN KEY ([TransactionStatusId]) REFERENCES [dbo].[ClaimCodeLookup] ([ClaimCodeLookupId]),
    CONSTRAINT [FK_BulkCheck_Party_01] FOREIGN KEY ([PartyId]) REFERENCES [dbo].[Party] ([PartyId])
) ON [CLAIMSCD];

