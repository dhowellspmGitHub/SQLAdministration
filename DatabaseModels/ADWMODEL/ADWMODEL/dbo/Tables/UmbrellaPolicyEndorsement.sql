CREATE TABLE [dbo].[UmbrellaPolicyEndorsement] (
    [EndorsementId]         INT            NOT NULL,
    [PolicyId]              INT            NOT NULL,
    [PolicyNbr]             VARCHAR (16)   NOT NULL,
    [EndorsementNbr]        CHAR (10)      NOT NULL,
    [EndorsementLimitCd]    CHAR (3)       NULL,
    [EndorsementLimitAmt]   DECIMAL (9)    NULL,
    [EndorsementPremiumAmt] DECIMAL (9, 2) NULL,
    [TrusteeNm]             VARCHAR (255)  NULL,
    [UpdatedTmstmp]         DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]         CHAR (8)       NOT NULL,
    [LastActionCd]          CHAR (1)       NOT NULL,
    [SourceSystemCd]        CHAR (2)       NOT NULL,
    CONSTRAINT [PK_UmbrellaPolicyEndorsement] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [EndorsementId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_UmbrellaPolicyEndorsement_Endorsements_01] FOREIGN KEY ([EndorsementId]) REFERENCES [dbo].[Endorsements] ([EndorsementId]),
    CONSTRAINT [FK_UmbrellaPolicyEndorsement_UmbrellaPolicy_01] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[UmbrellaPolicy] ([PolicyId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_UmbrellaPolicyEndorsement_01]
    ON [dbo].[UmbrellaPolicyEndorsement]([PolicyId] ASC)
    ON [POLICYCI];

