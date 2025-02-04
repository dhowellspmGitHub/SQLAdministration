CREATE TABLE [dbo].[PolicyPendingActivity] (
    [PendingId]             INT           NOT NULL,
    [PolicyNbr]             VARCHAR (16)  NOT NULL,
    [LineofBusinessCd]      CHAR (2)      NOT NULL,
    [SublineBusinessTypeCd] CHAR (1)      NOT NULL,
    [PendActionCd]          CHAR (3)      NOT NULL,
    [PendingCd]             CHAR (2)      NULL,
    [EffectiveDt]           DATE          NOT NULL,
    [ExpirationDt]          DATE          NULL,
    [PendingDt]             DATE          NULL,
    [RequestedId]           CHAR (4)      NULL,
    [UpdatedTmstmp]         DATETIME2 (7) NOT NULL,
    [UserUpdatedId]         CHAR (8)      NOT NULL,
    [LastActionCd]          CHAR (1)      NOT NULL,
    [SourceSystemCd]        CHAR (2)      NOT NULL,
    CONSTRAINT [PK_PolicyPendingActivity] PRIMARY KEY CLUSTERED ([PendingId] ASC) ON [POLICYCD]
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_PolicyPendingActivity_02]
    ON [dbo].[PolicyPendingActivity]([ExpirationDt] ASC)
    ON [POLICYCI];


GO
CREATE NONCLUSTERED INDEX [IX_PolicyPendingActivity_01]
    ON [dbo].[PolicyPendingActivity]([PolicyNbr] ASC)
    ON [POLICYCI];

