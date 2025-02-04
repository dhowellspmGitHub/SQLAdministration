CREATE TABLE [dbo].[ClaimPolicyAgent] (
    [ClaimPolicyId]  INT           NOT NULL,
    [AgentId]        INT           NOT NULL,
    [AgentNbr]       CHAR (4)      NOT NULL,
    [UpdatedTmstmp]  DATETIME2 (7) NOT NULL,
    [UserUpdatedId]  CHAR (8)      NOT NULL,
    [LastActionCd]   CHAR (1)      NOT NULL,
    [SourceSystemCd] CHAR (2)      NOT NULL,
    CONSTRAINT [PK_ClaimPolicyAgent] PRIMARY KEY CLUSTERED ([ClaimPolicyId] ASC, [AgentId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_ClaimPolicyAgent_Agent_01] FOREIGN KEY ([AgentId]) REFERENCES [dbo].[Agent] ([AgentId]),
    CONSTRAINT [FK_ClaimPolicyAgent_ClaimPolicy_01] FOREIGN KEY ([ClaimPolicyId]) REFERENCES [dbo].[ClaimPolicy] ([ClaimPolicyId])
) ON [CLAIMSCD];

