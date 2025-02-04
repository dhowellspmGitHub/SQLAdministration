CREATE TABLE [dbo].[ClaimExposureBridge] (
    [ExposureId]     INT           NOT NULL,
    [ClaimID]        INT           NOT NULL,
    [UserUpdatedId]  CHAR (8)      NOT NULL,
    [UpdatedTmstmp]  DATETIME2 (7) NOT NULL,
    [LastActionCd]   CHAR (1)      NOT NULL,
    [SourceSystemCd] CHAR (2)      NOT NULL,
    CONSTRAINT [PK_ClaimExposureBridge] PRIMARY KEY CLUSTERED ([ExposureId] ASC, [ClaimID] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_ClaimExposureBridge_Claim_01] FOREIGN KEY ([ClaimID]) REFERENCES [dbo].[Claim] ([ClaimID]),
    CONSTRAINT [FK_ClaimExposureBridge_Exposure_01] FOREIGN KEY ([ExposureId]) REFERENCES [dbo].[Exposure] ([ExposureId])
) ON [CLAIMSCD];

