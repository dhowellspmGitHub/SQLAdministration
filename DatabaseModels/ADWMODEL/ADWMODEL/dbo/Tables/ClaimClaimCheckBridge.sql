CREATE TABLE [dbo].[ClaimClaimCheckBridge] (
    [CheckId]        INT           NOT NULL,
    [ClaimID]        INT           NOT NULL,
    [UserUpdatedId]  CHAR (8)      NOT NULL,
    [UpdatedTmstmp]  DATETIME2 (7) NOT NULL,
    [LastActionCd]   CHAR (1)      NOT NULL,
    [SourceSystemCd] CHAR (2)      NOT NULL,
    CONSTRAINT [PK_ClaimClaimCheckBridge] PRIMARY KEY CLUSTERED ([CheckId] ASC, [ClaimID] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_ClaimClaimCheckBridge_Claim01] FOREIGN KEY ([ClaimID]) REFERENCES [dbo].[Claim] ([ClaimID]),
    CONSTRAINT [FK_ClaimClaimCheckBridge_ClaimCheck_01] FOREIGN KEY ([CheckId]) REFERENCES [dbo].[ClaimCheck] ([CheckId])
) ON [CLAIMSCD];

