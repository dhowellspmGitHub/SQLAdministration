CREATE TABLE [dbo].[ClaimPolicyClaimPolicyEndorsementBridge] (
    [EndorsementId]  INT           NOT NULL,
    [ClaimPolicyId]  INT           NOT NULL,
    [UserUpdatedId]  CHAR (8)      NOT NULL,
    [UpdatedTmstmp]  DATETIME2 (7) NOT NULL,
    [LastActionCd]   CHAR (1)      NOT NULL,
    [SourceSystemCd] CHAR (2)      NOT NULL,
    CONSTRAINT [PK_ClaimPolicyClaimPolicyEndorsementBridge] PRIMARY KEY NONCLUSTERED ([EndorsementId] ASC, [ClaimPolicyId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_CPCPEndorsementBridge_ClaimPolicy_01] FOREIGN KEY ([ClaimPolicyId]) REFERENCES [dbo].[ClaimPolicy] ([ClaimPolicyId]),
    CONSTRAINT [FK_CPCPEndorsementBridge_CPEndorsement_01] FOREIGN KEY ([EndorsementId]) REFERENCES [dbo].[ClaimPolicyEndorsement] ([EndorsementId])
) ON [CLAIMSCD];

