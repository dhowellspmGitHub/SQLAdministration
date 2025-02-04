CREATE TABLE [dbo].[QuoteAgent] (
    [QuoteNbr]       VARCHAR (16)  NOT NULL,
    [AgentId]        INT           NOT NULL,
    [UpdatedTmstmp]  DATETIME2 (7) NOT NULL,
    [UserUpdatedId]  CHAR (8)      NOT NULL,
    [LastActionCd]   CHAR (1)      NOT NULL,
    [SourceSystemCd] CHAR (2)      NOT NULL,
    CONSTRAINT [PK_QuoteAgent] PRIMARY KEY CLUSTERED ([QuoteNbr] ASC, [AgentId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_QuoteAgent_Agent_01] FOREIGN KEY ([AgentId]) REFERENCES [dbo].[Agent] ([AgentId]),
    CONSTRAINT [FK_QuoteAgent_Quote_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[Quote] ([QuoteNbr])
) ON [POLICYCD];

