CREATE TABLE [dbo].[SubrogationStatuteBridge] (
    [SubrogationDetailsId]              INT           NOT NULL,
    [SubrogationStatuteOfLimitationsId] INT           NOT NULL,
    [UpdatedTmstmp]                     DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                     CHAR (8)      NOT NULL,
    [LastActionCd]                      CHAR (1)      NOT NULL,
    [SourceSystemCd]                    CHAR (2)      NOT NULL,
    CONSTRAINT [PK_SubrogationStatuteBridge] PRIMARY KEY CLUSTERED ([SubrogationDetailsId] ASC, [SubrogationStatuteOfLimitationsId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_SubrogationStatuteBridge_SubrogationDetails_01] FOREIGN KEY ([SubrogationDetailsId]) REFERENCES [dbo].[SubrogationDetails] ([SubrogationDetailsId]),
    CONSTRAINT [FK_SubrogationStatuteBridge_SubrogationStatuteOfLimitations_01] FOREIGN KEY ([SubrogationStatuteOfLimitationsId]) REFERENCES [dbo].[SubrogationStatuteOfLimitations] ([SubrogationStatuteOfLimitationsId])
) ON [CLAIMSCD];

