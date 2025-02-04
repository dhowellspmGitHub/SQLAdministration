CREATE TABLE [dbo].[ExposureExcessOfLossReinsuranceBridge] (
    [ExposureId]                INT           NOT NULL,
    [ExcessOfLossReinsuranceId] INT           NOT NULL,
    [LastActionCd]              CHAR (1)      NOT NULL,
    [SourceSystemCd]            CHAR (2)      NOT NULL,
    [UpdatedTmstmp]             DATETIME2 (7) NOT NULL,
    [UserUpdatedId]             CHAR (8)      NOT NULL,
    CONSTRAINT [PK_ExposureExcessOfLossReinsuranceBridge] PRIMARY KEY NONCLUSTERED ([ExposureId] ASC, [ExcessOfLossReinsuranceId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_ExposureExcessOfLossReinsuranceBridge_ExcessOfLossReinsurance_01] FOREIGN KEY ([ExcessOfLossReinsuranceId]) REFERENCES [dbo].[ExcessOfLossReinsurance] ([ExcessOfLossReinsuranceId]),
    CONSTRAINT [FK_ExposureExcessOfLossReinsuranceBridge_Exposure_01] FOREIGN KEY ([ExposureId]) REFERENCES [dbo].[Exposure] ([ExposureId])
) ON [CLAIMSCD];

