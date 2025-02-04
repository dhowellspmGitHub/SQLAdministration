CREATE TABLE [dbo].[ClaimACVEstimatorBridge] (
    [ClaimID]        INT           NOT NULL,
    [ACVEStimatorId] INT           NOT NULL,
    [LastActionCd]   CHAR (1)      NOT NULL,
    [SourceSystemCd] CHAR (2)      NOT NULL,
    [UpdatedTmstmp]  DATETIME2 (7) NOT NULL,
    [UserUpdatedId]  CHAR (8)      NOT NULL,
    CONSTRAINT [PK_ClaimACVEstimateBridge] PRIMARY KEY CLUSTERED ([ClaimID] ASC, [ACVEStimatorId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_ClaimACVEstimatorBridge_ACVEstimator_01] FOREIGN KEY ([ACVEStimatorId]) REFERENCES [dbo].[ACVEstimator] ([ACVEStimatorId]),
    CONSTRAINT [FK_ClaimACVEstimatorBridge_Claim_01] FOREIGN KEY ([ClaimID]) REFERENCES [dbo].[Claim] ([ClaimID])
) ON [CLAIMSCD];

