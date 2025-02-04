CREATE TABLE [dbo].[ExposureReinsuranceSurplusQuotaShareBridge] (
    [ExposureId]                     INT           NOT NULL,
    [ReinsuranceSurplusQuotaShareId] INT           NOT NULL,
    [LastActionCd]                   CHAR (1)      NOT NULL,
    [SourceSystemCd]                 CHAR (2)      NOT NULL,
    [UpdatedTmstmp]                  DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                  CHAR (8)      NOT NULL,
    CONSTRAINT [PK_ExposureReinsuranceSurplusQuotaShareBridge] PRIMARY KEY NONCLUSTERED ([ExposureId] ASC, [ReinsuranceSurplusQuotaShareId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_ExposureReinsuranceSurplusQuotaShareBridge_Exposure_01] FOREIGN KEY ([ExposureId]) REFERENCES [dbo].[Exposure] ([ExposureId]),
    CONSTRAINT [FK_ExposureReinsuranceSurplusQuotaShareBridge_ReinsuranceSurplusQuotaShare_01] FOREIGN KEY ([ReinsuranceSurplusQuotaShareId]) REFERENCES [dbo].[ReinsuranceSurplusQuotaShare] ([ReinsuranceSurplusQuotaShareId])
) ON [CLAIMSCD];

