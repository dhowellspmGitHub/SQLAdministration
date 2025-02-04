CREATE TABLE [dbo].[ClaimPolicyClaimCoverageBridge] (
    [ClaimCoverageId] INT           NOT NULL,
    [ClaimPolicyId]   INT           NOT NULL,
    [UserUpdatedId]   CHAR (8)      NOT NULL,
    [UpdatedTmstmp]   DATETIME2 (7) NOT NULL,
    [LastActionCd]    CHAR (1)      NOT NULL,
    [SourceSystemCd]  CHAR (2)      NOT NULL,
    CONSTRAINT [PK_ClaimPolicyClaimCoverageBridge] PRIMARY KEY NONCLUSTERED ([ClaimCoverageId] ASC, [ClaimPolicyId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_ClaimPolicyClaimCoverageBridge_ClaimCoverage_01] FOREIGN KEY ([ClaimCoverageId]) REFERENCES [dbo].[ClaimCoverage] ([ClaimCoverageId]),
    CONSTRAINT [FK_ClaimPolicyClaimCoverageBridge_ClaimPolicy_01] FOREIGN KEY ([ClaimPolicyId]) REFERENCES [dbo].[ClaimPolicy] ([ClaimPolicyId])
) ON [CLAIMSCD];

