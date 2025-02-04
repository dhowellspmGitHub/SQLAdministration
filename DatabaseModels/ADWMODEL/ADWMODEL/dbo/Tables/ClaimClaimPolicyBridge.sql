CREATE TABLE [dbo].[ClaimClaimPolicyBridge] (
    [ClaimID]        INT           NOT NULL,
    [ClaimPolicyId]  INT           NOT NULL,
    [UserUpdatedId]  CHAR (8)      NOT NULL,
    [UpdatedTmstmp]  DATETIME2 (7) NOT NULL,
    [LastActionCd]   CHAR (1)      NOT NULL,
    [SourceSystemCd] CHAR (2)      NOT NULL,
    CONSTRAINT [PK_ClaimClaimPolicyBridge] PRIMARY KEY NONCLUSTERED ([ClaimID] ASC, [ClaimPolicyId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_ClaimClaimPolicyBridge_Claim_01] FOREIGN KEY ([ClaimID]) REFERENCES [dbo].[Claim] ([ClaimID]),
    CONSTRAINT [FK_ClaimClaimPolicyBridge_ClaimPolicy_01] FOREIGN KEY ([ClaimPolicyId]) REFERENCES [dbo].[ClaimPolicy] ([ClaimPolicyId])
) ON [CLAIMSCD];

