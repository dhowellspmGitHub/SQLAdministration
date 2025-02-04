CREATE TABLE [dbo].[SubrogationStatuteOfLimitations] (
    [SubrogationStatuteOfLimitationsId] INT           NOT NULL,
    [JurisdictionStateId]               INT           NULL,
    [StatuteLimitTypeId]                INT           NULL,
    [StatuteDt]                         DATE          NULL,
    [StatuteLimitDesc]                  VARCHAR (255) NULL,
    [CurrentRecordInd]                  BIT           NOT NULL,
    [RetiredInd]                        CHAR (1)      NOT NULL,
    [SourceSystemId]                    INT           NOT NULL,
    [SourceSystemCreatedTmstmp]         DATETIME2 (7) NOT NULL,
    [SourceSystemUserCreatedId]         CHAR (10)     NOT NULL,
    [SourceSystemUpdatedTmstmp]         DATETIME2 (7) NOT NULL,
    [SourceSystemUserUpdatedId]         CHAR (10)     NOT NULL,
    [UpdatedTmstmp]                     DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                     CHAR (8)      NOT NULL,
    [LastActionCd]                      CHAR (1)      NOT NULL,
    [SourceSystemCd]                    CHAR (2)      NOT NULL,
    CONSTRAINT [PK_SubrogationStatuteOfLimitations] PRIMARY KEY CLUSTERED ([SubrogationStatuteOfLimitationsId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_SubrogationStatuteOfLimitations_ClaimCodeLookup_01] FOREIGN KEY ([JurisdictionStateId]) REFERENCES [dbo].[ClaimCodeLookup] ([ClaimCodeLookupId]),
    CONSTRAINT [FK_SubrogationStatuteOfLimitations_ClaimCodeLookup_05] FOREIGN KEY ([StatuteLimitTypeId]) REFERENCES [dbo].[ClaimCodeLookup] ([ClaimCodeLookupId])
) ON [CLAIMSCD];

