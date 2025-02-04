CREATE TABLE [dbo].[MemberPreference] (
    [MemberPreferenceId]     INT           IDENTITY (1, 1) NOT NULL,
    [EBusinessId]            VARCHAR (35)  NOT NULL,
    [PartyId]                INT           NOT NULL,
    [MembershipId]           INT           NOT NULL,
    [ClientReferenceNbr]     CHAR (10)     NOT NULL,
    [CommunicationTypeCd]    CHAR (2)      NOT NULL,
    [CommunicationDesc]      VARCHAR (40)  NOT NULL,
    [EffectiveDt]            DATE          NOT NULL,
    [NotificationSentTmstmp] DATETIME2 (7) NOT NULL,
    [NotificationStatusCd]   CHAR (2)      NOT NULL,
    [UpdatedTmstmp]          DATETIME2 (7) NOT NULL,
    [UserUpdatedId]          CHAR (8)      NOT NULL,
    [UserCreatedId]          CHAR (8)      NOT NULL,
    [CreatedTmstmp]          DATETIME      NOT NULL,
    [SourceSystemCd]         CHAR (2)      NOT NULL,
    [LastActionCd]           CHAR (1)      NOT NULL,
    CONSTRAINT [PK_MemberPreference] PRIMARY KEY CLUSTERED ([MemberPreferenceId] ASC) ON [MEMBERCD],
    CONSTRAINT [FK_MemberPreference_eBusinessProfile_01] FOREIGN KEY ([EBusinessId]) REFERENCES [dbo].[eBusinessProfile] ([EBusinessId]),
    CONSTRAINT [FK_MemberPreference_Membership_01] FOREIGN KEY ([MembershipId]) REFERENCES [dbo].[Membership] ([MembershipId]),
    CONSTRAINT [FK_MemberPreference_Party_01] FOREIGN KEY ([PartyId]) REFERENCES [dbo].[Party] ([PartyId])
) ON [MEMBERCD];

