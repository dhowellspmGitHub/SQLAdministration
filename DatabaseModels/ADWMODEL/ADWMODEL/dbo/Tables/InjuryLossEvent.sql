CREATE TABLE [dbo].[InjuryLossEvent] (
    [LossEventId]            INT           NOT NULL,
    [DetailedInjuryTypeId]   INT           NULL,
    [GeneralInjuryTypeId]    INT           NULL,
    [MedicalTreatmentTypeId] INT           NULL,
    [ClaimUserCreateTime]    DATETIME2 (7) NOT NULL,
    [ClaimUserCreatedId]     CHAR (8)      NOT NULL,
    [ClaimUpdatedTmstmp]     DATETIME2 (7) NOT NULL,
    [ClaimUserUpdatedId]     CHAR (8)      NOT NULL,
    [RetiredInd]             CHAR (1)      NOT NULL,
    [SourceSystemId]         INT           NOT NULL,
    [UpdatedTmstmp]          DATETIME2 (7) NOT NULL,
    [UserUpdatedId]          CHAR (8)      NOT NULL,
    [LastActionCd]           CHAR (1)      NOT NULL,
    [SourceSystemCd]         CHAR (2)      NOT NULL,
    CONSTRAINT [PK_InjuryLossEvent] PRIMARY KEY CLUSTERED ([LossEventId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_InjuryLossEvent_ClaimCodeLookup_01] FOREIGN KEY ([MedicalTreatmentTypeId]) REFERENCES [dbo].[ClaimCodeLookup] ([ClaimCodeLookupId]),
    CONSTRAINT [FK_InjuryLossEvent_ClaimCodeLookup_02] FOREIGN KEY ([DetailedInjuryTypeId]) REFERENCES [dbo].[ClaimCodeLookup] ([ClaimCodeLookupId]),
    CONSTRAINT [FK_InjuryLossEvent_ClaimCodeLookup_03] FOREIGN KEY ([GeneralInjuryTypeId]) REFERENCES [dbo].[ClaimCodeLookup] ([ClaimCodeLookupId]),
    CONSTRAINT [FK_InjuryLossEvent_LossEvent_01] FOREIGN KEY ([LossEventId]) REFERENCES [dbo].[LossEvent] ([LossEventId])
) ON [CLAIMSCD];

