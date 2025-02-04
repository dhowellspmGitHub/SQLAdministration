CREATE TABLE [dbo].[ClaimExternalAdjusterBridge] (
    [ClaimID]                 INT           NOT NULL,
    [ClaimExternalAdjusterId] INT           NOT NULL,
    [UpdatedTmstmp]           DATETIME2 (7) NOT NULL,
    [UserUpdatedCd]           CHAR (10)     NOT NULL,
    [LastActionCd]            CHAR (1)      NOT NULL,
    [SourceSystemCd]          CHAR (2)      NOT NULL,
    CONSTRAINT [PK_ClaimExternalAdjusterBridge] PRIMARY KEY CLUSTERED ([ClaimID] ASC, [ClaimExternalAdjusterId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_ClaimExternalAdjusterBridge_Claim_01] FOREIGN KEY ([ClaimID]) REFERENCES [dbo].[Claim] ([ClaimID]),
    CONSTRAINT [FK_ClaimExternalAdjusterBridge_ClaimExternalAdjuster_01] FOREIGN KEY ([ClaimExternalAdjusterId]) REFERENCES [dbo].[ClaimExternalAdjuster] ([ClaimExternalAdjusterId])
) ON [CLAIMSCD];

