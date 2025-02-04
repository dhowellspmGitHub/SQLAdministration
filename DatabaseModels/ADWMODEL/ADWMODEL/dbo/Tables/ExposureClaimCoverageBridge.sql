CREATE TABLE [dbo].[ExposureClaimCoverageBridge] (
    [ExposureId]      INT           NOT NULL,
    [ClaimCoverageId] INT           NOT NULL,
    [UserUpdatedId]   CHAR (8)      NOT NULL,
    [UpdatedTmstmp]   DATETIME2 (7) NOT NULL,
    [LastActionCd]    CHAR (1)      NOT NULL,
    [SourceSystemCd]  CHAR (2)      NOT NULL,
    CONSTRAINT [PK_ExposureClaimCoverageBridge] PRIMARY KEY NONCLUSTERED ([ExposureId] ASC, [ClaimCoverageId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_ExposureClaimCoverageBridge_ClaimCoverage_01] FOREIGN KEY ([ClaimCoverageId]) REFERENCES [dbo].[ClaimCoverage] ([ClaimCoverageId]),
    CONSTRAINT [FK_ExposureClaimCoverageBridge_Exposure] FOREIGN KEY ([ExposureId]) REFERENCES [dbo].[Exposure] ([ExposureId])
) ON [CLAIMSCD];

