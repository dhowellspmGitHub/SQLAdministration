CREATE TABLE [dbo].[PolicyMembership] (
    [PolicyId]       INT           NOT NULL,
    [MembershipId]   INT           NOT NULL,
    [UpdatedTmstmp]  DATETIME2 (7) NOT NULL,
    [UserUpdatedId]  CHAR (8)      NOT NULL,
    [LastActionCd]   CHAR (1)      NOT NULL,
    [SourceSystemCd] CHAR (2)      NOT NULL,
    CONSTRAINT [PK_PolicyMembership] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [MembershipId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_PolicyMembership_Membership_01] FOREIGN KEY ([MembershipId]) REFERENCES [dbo].[Membership] ([MembershipId]),
    CONSTRAINT [FK_PolicyMembership_Policy_01] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[Policy] ([PolicyId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_PolicyMembership_01]
    ON [dbo].[PolicyMembership]([PolicyId] ASC)
    ON [POLICYCI];

