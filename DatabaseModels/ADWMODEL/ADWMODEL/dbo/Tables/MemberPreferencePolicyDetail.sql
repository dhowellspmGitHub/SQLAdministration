CREATE TABLE [dbo].[MemberPreferencePolicyDetail] (
    [MemberPreferenceDetailId] INT           IDENTITY (1, 1) NOT NULL,
    [MemberPreferenceId]       INT           NOT NULL,
    [PolicyId]                 INT           NOT NULL,
    [PolicyNbr]                VARCHAR (16)  NOT NULL,
    [LineofBusinessCd]         CHAR (2)      NOT NULL,
    [EnrollmentStatusCd]       CHAR (2)      NOT NULL,
    [DesignationInd]           CHAR (1)      NULL,
    [EmailPreferenceTypeCd]    CHAR (3)      NULL,
    [TextPreferenceTypeCd]     CHAR (3)      NULL,
    [EffectiveDt]              DATE          NOT NULL,
    [UpdatedTmstmp]            DATETIME2 (7) NOT NULL,
    [UserCreatedId]            CHAR (8)      NOT NULL,
    [CreatedTmstmp]            DATETIME      NOT NULL,
    [UserUpdatedId]            CHAR (8)      NOT NULL,
    [SourceSystemCd]           CHAR (2)      NOT NULL,
    [LastActionCd]             CHAR (1)      NOT NULL,
    CONSTRAINT [PK_MemberPreferenceDetail] PRIMARY KEY CLUSTERED ([MemberPreferenceDetailId] ASC) ON [MEMBERCD],
    CONSTRAINT [FK_MemberPreferenceDetail_MemberPreference_01] FOREIGN KEY ([MemberPreferenceId]) REFERENCES [dbo].[MemberPreference] ([MemberPreferenceId]),
    CONSTRAINT [FK_MemberPreferencePolicyDetail_Policy_01] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[Policy] ([PolicyId])
) ON [MEMBERCD];

