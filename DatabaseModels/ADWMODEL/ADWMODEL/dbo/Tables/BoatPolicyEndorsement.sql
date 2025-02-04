CREATE TABLE [dbo].[BoatPolicyEndorsement] (
    [EndorsementId]                  INT            NOT NULL,
    [PolicyId]                       INT            NOT NULL,
    [PolicyNbr]                      VARCHAR (16)   NOT NULL,
    [EndorsementNbr]                 CHAR (10)      NOT NULL,
    [EndorsementLimitCd]             CHAR (3)       NULL,
    [EndorsementLimitAmt]            DECIMAL (9)    NULL,
    [EndorsementPremiumAmt]          DECIMAL (9, 2) NULL,
    [UnscheduledPersonalPropertyInd] CHAR (1)       NULL,
    [UpdatedTmstmp]                  DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]                  CHAR (8)       NOT NULL,
    [LastActionCd]                   CHAR (1)       NOT NULL,
    [SourceSystemCd]                 CHAR (2)       NOT NULL,
    CONSTRAINT [PK_BoatPolicyEndorsement] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [EndorsementId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_BoatPolicyEndorsement_BoatPolicy_01] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[BoatPolicy] ([PolicyId]),
    CONSTRAINT [FK_BoatPolicyEndorsement_Endorsements_01] FOREIGN KEY ([EndorsementId]) REFERENCES [dbo].[Endorsements] ([EndorsementId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_BoatPolicyEndorsement_01]
    ON [dbo].[BoatPolicyEndorsement]([PolicyId] ASC)
    ON [POLICYCI];

