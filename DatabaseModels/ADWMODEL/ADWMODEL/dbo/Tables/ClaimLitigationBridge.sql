CREATE TABLE [dbo].[ClaimLitigationBridge] (
    [ClaimID]        INT           NOT NULL,
    [LitigationId]   INT           NOT NULL,
    [UserUpdatedId]  CHAR (8)      NOT NULL,
    [UpdatedTmstmp]  DATETIME2 (7) NOT NULL,
    [LastActionCd]   CHAR (1)      NOT NULL,
    [SourceSystemCd] CHAR (2)      NOT NULL,
    CONSTRAINT [PK_ClaimLitigationBridge] PRIMARY KEY NONCLUSTERED ([ClaimID] ASC, [LitigationId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_ClaimLitigationBridge_Claim_01] FOREIGN KEY ([ClaimID]) REFERENCES [dbo].[Claim] ([ClaimID]),
    CONSTRAINT [FK_ClaimLitigationBridge_Litigation_01] FOREIGN KEY ([LitigationId]) REFERENCES [dbo].[Litigation] ([LitigationId])
) ON [CLAIMSCD];

