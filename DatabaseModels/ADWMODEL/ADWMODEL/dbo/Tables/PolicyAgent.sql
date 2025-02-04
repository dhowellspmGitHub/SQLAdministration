CREATE TABLE [dbo].[PolicyAgent] (
    [PolicyId]            INT           NOT NULL,
    [NewBusinessAgentId]  INT           NOT NULL,
    [RenewalAgentId]      INT           NOT NULL,
    [NewBusinessAgentNbr] CHAR (4)      NOT NULL,
    [RenewalAgentNbr]     CHAR (4)      NOT NULL,
    [UpdatedTmstmp]       DATETIME2 (7) NOT NULL,
    [UserUpdatedId]       CHAR (8)      NOT NULL,
    [LastActionCd]        CHAR (1)      NOT NULL,
    [SourceSystemCd]      CHAR (2)      NOT NULL,
    CONSTRAINT [PK_PolicyAgent] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [NewBusinessAgentId] ASC, [RenewalAgentId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_PolicyAgent_Agent_01] FOREIGN KEY ([RenewalAgentId]) REFERENCES [dbo].[Agent] ([AgentId]),
    CONSTRAINT [FK_PolicyAgent_Agent_02] FOREIGN KEY ([NewBusinessAgentId]) REFERENCES [dbo].[Agent] ([AgentId]),
    CONSTRAINT [FK_PolicyAgent_Policy_01] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[Policy] ([PolicyId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_PolicyAgent_01]
    ON [dbo].[PolicyAgent]([PolicyId] ASC)
    ON [POLICYCI];

