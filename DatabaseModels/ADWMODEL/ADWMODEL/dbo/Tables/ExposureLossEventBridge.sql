CREATE TABLE [dbo].[ExposureLossEventBridge] (
    [LossEventId]    INT           NOT NULL,
    [ExposureId]     INT           NOT NULL,
    [UserUpdatedId]  CHAR (8)      NOT NULL,
    [UpdatedTmstmp]  DATETIME2 (7) NOT NULL,
    [LastActionCd]   CHAR (1)      NOT NULL,
    [SourceSystemCd] CHAR (2)      NOT NULL,
    CONSTRAINT [PK_ExposureLossEventBridge] PRIMARY KEY CLUSTERED ([LossEventId] ASC, [ExposureId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_ExposureLossEventBridge_Exposure_01] FOREIGN KEY ([ExposureId]) REFERENCES [dbo].[Exposure] ([ExposureId]),
    CONSTRAINT [FK_ExposureLossEventBridge_LossEvent_01] FOREIGN KEY ([LossEventId]) REFERENCES [dbo].[LossEvent] ([LossEventId])
) ON [CLAIMSCD];

