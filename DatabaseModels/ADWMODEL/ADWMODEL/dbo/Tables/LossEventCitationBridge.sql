CREATE TABLE [dbo].[LossEventCitationBridge] (
    [CitationId]     INT           NOT NULL,
    [LossEventId]    INT           NOT NULL,
    [UserUpdatedId]  CHAR (8)      NOT NULL,
    [UpdatedTmstmp]  DATETIME2 (7) NOT NULL,
    [LastActionCd]   CHAR (1)      NOT NULL,
    [SourceSystemCd] CHAR (2)      NOT NULL,
    CONSTRAINT [PK_LossEventCitationBridge] PRIMARY KEY NONCLUSTERED ([CitationId] ASC, [LossEventId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_LossEventCitationBridge_Citation_01] FOREIGN KEY ([CitationId]) REFERENCES [dbo].[Citation] ([CitationId]),
    CONSTRAINT [FK_LossEventCitationBridge_LossEvent_01] FOREIGN KEY ([LossEventId]) REFERENCES [dbo].[LossEvent] ([LossEventId])
) ON [CLAIMSCD];

