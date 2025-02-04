CREATE TABLE [dbo].[ClaimAssociatedClaimsBridge] (
    [ClaimID]            INT           NOT NULL,
    [AssociatedClaimsId] INT           NOT NULL,
    [UpdatedTmstmp]      DATETIME2 (7) NOT NULL,
    [UserUpdatedId]      CHAR (8)      NOT NULL,
    [LastActionCd]       CHAR (1)      NOT NULL,
    [SourceSystemCd]     CHAR (2)      NOT NULL,
    CONSTRAINT [PK_ClaimAssociatedClaimsBridge] PRIMARY KEY CLUSTERED ([ClaimID] ASC, [AssociatedClaimsId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_ClaimAssociatedClaimsBridge_AssociatedClaims_01] FOREIGN KEY ([AssociatedClaimsId]) REFERENCES [dbo].[AssociatedClaims] ([AssociatedClaimsId]),
    CONSTRAINT [FK_ClaimAssociatedClaimsBridge_Claim] FOREIGN KEY ([ClaimID]) REFERENCES [dbo].[Claim] ([ClaimID])
) ON [CLAIMSCD];

