CREATE TABLE [dbo].[ClaimPolicyClaimPolicyLocationBridge] (
    [ClaimPolicyLocationID] INT           NOT NULL,
    [ClaimPolicyId]         INT           NOT NULL,
    [LastActionCd]          CHAR (1)      NOT NULL,
    [SourceSystemCd]        CHAR (2)      NOT NULL,
    [UpdatedTmstmp]         DATETIME2 (7) NOT NULL,
    [UserUpdatedId]         CHAR (8)      NOT NULL,
    CONSTRAINT [PK_ClaimPolicyClaimPolicyLocationBridge] PRIMARY KEY CLUSTERED ([ClaimPolicyLocationID] ASC, [ClaimPolicyId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_ClaimPolicyClaimPolicyLocationBridge_ClaimPolicy_01] FOREIGN KEY ([ClaimPolicyId]) REFERENCES [dbo].[ClaimPolicy] ([ClaimPolicyId]),
    CONSTRAINT [FK_ClaimPolicyClaimPolicyLocationBridge_ClaimPolicyLocation_01] FOREIGN KEY ([ClaimPolicyLocationID]) REFERENCES [dbo].[ClaimPolicyLocation] ([ClaimPolicyLocationID])
) ON [CLAIMSCD];

