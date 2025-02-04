CREATE TABLE [dbo].[LitigationClaimActivitiyBridge] (
    [LitigationId]    INT           NULL,
    [ClaimActivityId] INT           NULL,
    [UserUpdatedId]   CHAR (8)      NOT NULL,
    [UpdatedTmstmp]   DATETIME2 (7) NOT NULL,
    [SourceSystemCd]  CHAR (2)      NOT NULL,
    [LastActionCd]    CHAR (1)      NOT NULL,
    CONSTRAINT [FK_LitigationClaimActivitiyBridge_ClaimActivity_01] FOREIGN KEY ([ClaimActivityId]) REFERENCES [dbo].[ClaimActivity] ([ClaimActivityId]),
    CONSTRAINT [FK_LitigationClaimActivityBridge_Litigation_01] FOREIGN KEY ([LitigationId]) REFERENCES [dbo].[Litigation] ([LitigationId])
) ON [CLAIMSCD];

