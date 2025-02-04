CREATE TABLE [dbo].[ClaimLossEventBridge] (
    [LossEventId]    INT           NOT NULL,
    [ClaimID]        INT           NOT NULL,
    [UserUpdatedId]  CHAR (8)      NOT NULL,
    [UpdatedTmstmp]  DATETIME2 (7) NOT NULL,
    [LastActionCd]   CHAR (1)      NOT NULL,
    [SourceSystemCd] CHAR (2)      NOT NULL,
    CONSTRAINT [PK_ClaimLossEventBridge] PRIMARY KEY CLUSTERED ([LossEventId] ASC, [ClaimID] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_ClaimLossEventBridge_Claim_01] FOREIGN KEY ([ClaimID]) REFERENCES [dbo].[Claim] ([ClaimID]),
    CONSTRAINT [FK_ClaimLossEventBridge_LossEvent_01] FOREIGN KEY ([LossEventId]) REFERENCES [dbo].[LossEvent] ([LossEventId])
) ON [CLAIMSCD];

