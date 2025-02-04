CREATE TABLE [dbo].[ClaimClaimGroupBridge] (
    [ClaimID]        INT           NOT NULL,
    [ClaimGroupId]   INT           NOT NULL,
    [UpdatedTmstmp]  DATETIME2 (7) NOT NULL,
    [UserUpdatedId]  CHAR (8)      NOT NULL,
    [LastActionCd]   CHAR (1)      NOT NULL,
    [SourceSystemCd] CHAR (2)      NOT NULL,
    CONSTRAINT [PK_ClaimClaimGroupBridge] PRIMARY KEY CLUSTERED ([ClaimID] ASC, [ClaimGroupId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_ClaimClaimGroupBridge_Claim_01] FOREIGN KEY ([ClaimID]) REFERENCES [dbo].[Claim] ([ClaimID]),
    CONSTRAINT [FK_ClaimClaimGroupBridge_ClaimGroup_01] FOREIGN KEY ([ClaimGroupId]) REFERENCES [dbo].[ClaimGroup] ([ClaimGroupId])
) ON [CLAIMSCD];

