CREATE TABLE [dbo].[ExposureExposureReserveAmountsBridge] (
    [ExposureAmountsId] INT           NOT NULL,
    [ExposureId]        INT           NOT NULL,
    [UpdatedTmstmp]     DATETIME2 (7) NOT NULL,
    [UserUpdatedId]     CHAR (8)      NOT NULL,
    [LastActionCd]      CHAR (1)      NOT NULL,
    [SourceSystemCd]    CHAR (2)      NOT NULL,
    CONSTRAINT [PK_ExposureExposureReserveAmountsBridge] PRIMARY KEY CLUSTERED ([ExposureAmountsId] ASC, [ExposureId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_ExposureExposureReserveAmountsBridge_Exposure_01] FOREIGN KEY ([ExposureId]) REFERENCES [dbo].[Exposure] ([ExposureId]),
    CONSTRAINT [FK_ExposureExposureReserveAmountsBridge_ExposureReserveAmounts_01] FOREIGN KEY ([ExposureAmountsId]) REFERENCES [dbo].[ExposureReserveAmounts] ([ExposureAmountsId])
) ON [CLAIMSCD];

