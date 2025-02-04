CREATE TABLE [dbo].[LitigationExposureBridge] (
    [LitigationId]        INT           NOT NULL,
    [ExposureId]          INT           NOT NULL,
    [UserUpdatedId]       CHAR (8)      NOT NULL,
    [FinalSettlementAmt]  MONEY         NULL,
    [MCASReportableIndCd] VARCHAR (10)  NULL,
    [LastPreSuitOfferAmt] MONEY         NULL,
    [UpdatedTmstmp]       DATETIME2 (7) NOT NULL,
    [LastActionCd]        CHAR (1)      NOT NULL,
    [SourceSystemCd]      CHAR (2)      NOT NULL,
    CONSTRAINT [PK_LitigationExposureBridge] PRIMARY KEY NONCLUSTERED ([LitigationId] ASC, [ExposureId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_LitigationExposure_Exposure_01] FOREIGN KEY ([ExposureId]) REFERENCES [dbo].[Exposure] ([ExposureId]),
    CONSTRAINT [FK_LitigationExposureBridge_Litigation_01] FOREIGN KEY ([LitigationId]) REFERENCES [dbo].[Litigation] ([LitigationId])
) ON [CLAIMSCD];

