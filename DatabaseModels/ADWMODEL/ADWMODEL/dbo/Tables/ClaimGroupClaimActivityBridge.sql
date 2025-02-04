CREATE TABLE [dbo].[ClaimGroupClaimActivityBridge] (
    [ClaimGroupId]    INT           NULL,
    [ClaimActivityId] INT           NULL,
    [UserUpdatedId]   CHAR (8)      NOT NULL,
    [UpdatedTmstmp]   DATETIME2 (7) NOT NULL,
    [SourceSystemCd]  CHAR (2)      NOT NULL,
    [LastActionCd]    CHAR (1)      NOT NULL,
    CONSTRAINT [FK_ClaimGroupClaimActivityBridge_ClaimActivity_01] FOREIGN KEY ([ClaimActivityId]) REFERENCES [dbo].[ClaimActivity] ([ClaimActivityId]),
    CONSTRAINT [FK_ClaimGroupClaimActivityBridge_ClaimGroup_01] FOREIGN KEY ([ClaimGroupId]) REFERENCES [dbo].[ClaimGroup] ([ClaimGroupId])
) ON [CLAIMSCD];

