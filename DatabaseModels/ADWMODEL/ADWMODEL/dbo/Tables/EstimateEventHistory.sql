CREATE TABLE [dbo].[EstimateEventHistory] (
    [EstimateEventHistoryId]    INT           NOT NULL,
    [PropertyEstimateStatusId]  INT           NULL,
    [EventCreatedDt]            DATE          NULL,
    [CurrentRecordInd]          BIT           NOT NULL,
    [RetiredInd]                CHAR (1)      NOT NULL,
    [SourceSystemId]            INT           NOT NULL,
    [SourceSystemCreatedTmstmp] DATETIME2 (7) NOT NULL,
    [SourceSystemUserCreatedCd] CHAR (10)     NOT NULL,
    [SourceSystemUpdatedTmstmp] DATETIME2 (7) NOT NULL,
    [SourceSystemUserUpdatedCd] CHAR (10)     NOT NULL,
    [UpdatedTmstmp]             DATETIME2 (7) NOT NULL,
    [UserUpdatedCd]             CHAR (10)     NOT NULL,
    [LastActionCd]              CHAR (1)      NOT NULL,
    [SourceSystemCd]            CHAR (2)      NOT NULL,
    CONSTRAINT [PK_EstimateEventHistory] PRIMARY KEY CLUSTERED ([EstimateEventHistoryId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_EstimateEventHistory_ClaimCodeLookup_01] FOREIGN KEY ([PropertyEstimateStatusId]) REFERENCES [dbo].[ClaimCodeLookup] ([ClaimCodeLookupId])
) ON [CLAIMSCD];

