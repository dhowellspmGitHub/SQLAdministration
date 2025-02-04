CREATE TABLE [dbo].[ClaimExtAdjEstimateEventHistBridge] (
    [ClaimExternalAdjusterId] INT           NOT NULL,
    [EstimateEventHistoryId]  INT           NOT NULL,
    [UpdatedTmstmp]           DATETIME2 (7) NOT NULL,
    [UserUpdatedCd]           CHAR (10)     NOT NULL,
    [LastActionCd]            CHAR (1)      NOT NULL,
    [SourceSystemCd]          CHAR (2)      NOT NULL,
    CONSTRAINT [PK_ClaimExternalAdjusterEstimateEventHistoryBridge] PRIMARY KEY CLUSTERED ([ClaimExternalAdjusterId] ASC, [EstimateEventHistoryId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_ClaimExternalAdjusterEstimateEventHistoryBridge_ClaimExternalAdjuster_01] FOREIGN KEY ([ClaimExternalAdjusterId]) REFERENCES [dbo].[ClaimExternalAdjuster] ([ClaimExternalAdjusterId]),
    CONSTRAINT [FK_ClaimExternalAdjusterEstimateEventHistoryBridge_EstimateEventHistory_01] FOREIGN KEY ([EstimateEventHistoryId]) REFERENCES [dbo].[EstimateEventHistory] ([EstimateEventHistoryId])
) ON [CLAIMSCD];

