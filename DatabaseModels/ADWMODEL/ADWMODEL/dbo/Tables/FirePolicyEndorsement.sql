CREATE TABLE [dbo].[FirePolicyEndorsement] (
    [PolicyId]              INT            NOT NULL,
    [EndorsementId]         INT            NOT NULL,
    [PolicyNbr]             VARCHAR (16)   NOT NULL,
    [EndorsementNbr]        CHAR (10)      NOT NULL,
    [EndorsementLimitCd]    CHAR (3)       NULL,
    [EndorsementLimitAmt]   DECIMAL (9)    NULL,
    [EndorsementPremiumAmt] DECIMAL (9, 2) NULL,
    [UpdatedTmstmp]         DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]         CHAR (8)       NOT NULL,
    [LastActionCd]          CHAR (1)       NOT NULL,
    [SourceSystemCd]        CHAR (2)       NOT NULL,
    CONSTRAINT [PK_FirePolicyEndorsement] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [EndorsementId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FirePolicyEndorsement_Endorsements_01] FOREIGN KEY ([EndorsementId]) REFERENCES [dbo].[Endorsements] ([EndorsementId]),
    CONSTRAINT [FK_FirePolicyEndorsement_FirePolicy_01] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[FirePolicy] ([PolicyId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_FirePolicyEndorsement_01]
    ON [dbo].[FirePolicyEndorsement]([PolicyId] ASC)
    ON [POLICYCI];

