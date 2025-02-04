CREATE TABLE [dbo].[CheckPayee] (
    [CheckPayeeId]         INT           NOT NULL,
    [ClaimUserCreateTime]  DATETIME2 (7) NOT NULL,
    [ClaimUserUpdatedTime] DATETIME2 (7) NOT NULL,
    [ClaimUserCreatedId]   CHAR (8)      NOT NULL,
    [ClaimUserUpdatedId]   CHAR (8)      NOT NULL,
    [CurrentRecordInd]     BIT           NOT NULL,
    [UserUpdatedId]        CHAR (8)      NOT NULL,
    [UpdatedTmstmp]        DATETIME2 (7) NOT NULL,
    [LastActionCd]         CHAR (1)      NOT NULL,
    [Payee1099TaxableInd]  CHAR (1)      NULL,
    [PayeeTypeId]          INT           NOT NULL,
    [RetiredInd]           CHAR (1)      NOT NULL,
    [SourceSystemCd]       CHAR (2)      NOT NULL,
    [SourceSystemId]       INT           NOT NULL,
    [PayeeId]              INT           NULL,
    CONSTRAINT [PK_CheckPayee] PRIMARY KEY CLUSTERED ([CheckPayeeId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_CheckPayee_ClaimCodeLookup_01] FOREIGN KEY ([PayeeTypeId]) REFERENCES [dbo].[ClaimCodeLookup] ([ClaimCodeLookupId]),
    CONSTRAINT [FK_CheckPayee_Party_01] FOREIGN KEY ([PayeeId]) REFERENCES [dbo].[Party] ([PartyId])
) ON [CLAIMSCD];

