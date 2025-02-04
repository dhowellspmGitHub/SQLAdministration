CREATE TABLE [dbo].[CommercialIMEndorsement] (
    [PolicyId]                 INT            NOT NULL,
    [EndorsementId]            INT            NOT NULL,
    [EndorsementNbr]           CHAR (10)      NOT NULL,
    [LocationID]               BIGINT         NULL,
    [PolicyNbr]                VARCHAR (16)   NOT NULL,
    [EndorsementLimitCd]       CHAR (3)       NULL,
    [EndorsementLimitAmt]      DECIMAL (9)    NULL,
    [EndorsementPremiumAmt]    DECIMAL (9, 2) NULL,
    [EndorsementDeductibleAmt] DECIMAL (9)    NULL,
    [CreatedTmstmp]            DATETIME       NOT NULL,
    [UserCreatedId]            CHAR (8)       NOT NULL,
    [UpdatedTmstmp]            DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]            CHAR (8)       NOT NULL,
    [LastActionCd]             CHAR (1)       NOT NULL,
    [SourceSystemCd]           CHAR (2)       NOT NULL,
    CONSTRAINT [PK_CommercialIMEndorsement] PRIMARY KEY CLUSTERED ([EndorsementNbr] ASC, [EndorsementId] ASC, [PolicyId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialIMEndorsement_CommercialPolicy_01] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[CommercialPolicy] ([PolicyId]),
    CONSTRAINT [FK_CommercialIMEndorsement_Endorsements_01] FOREIGN KEY ([EndorsementId]) REFERENCES [dbo].[Endorsements] ([EndorsementId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialIMEndorsement_01]
    ON [dbo].[CommercialIMEndorsement]([PolicyId] ASC)
    ON [POLICYCI];

