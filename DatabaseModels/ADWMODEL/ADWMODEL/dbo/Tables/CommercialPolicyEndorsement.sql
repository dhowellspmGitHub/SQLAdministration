CREATE TABLE [dbo].[CommercialPolicyEndorsement] (
    [EndorsementId]                     INT            NOT NULL,
    [PolicyId]                          INT            NOT NULL,
    [PolicyNbr]                         VARCHAR (16)   NOT NULL,
    [EndorsementNbr]                    CHAR (10)      NOT NULL,
    [EndorsementLimitCd]                CHAR (3)       NULL,
    [EndorsementLimitAmt]               DECIMAL (9)    NULL,
    [EndorsementPremiumAmt]             DECIMAL (9, 2) NULL,
    [EndorsementDeductibleAmt]          DECIMAL (9)    NULL,
    [CompanyOrClientNm]                 VARCHAR (255)  NULL,
    [BusinessIncomeExtraExpenseDaysNbr] INT            NULL,
    [UpdatedTmstmp]                     DATETIME2 (7)  NOT NULL,
    [IncreasedLimitAmt]                 DECIMAL (9)    NULL,
    [UserUpdatedId]                     CHAR (8)       NOT NULL,
    [LastActionCd]                      CHAR (1)       NOT NULL,
    [SourceSystemCd]                    CHAR (2)       NOT NULL,
    CONSTRAINT [PK_CommercialPolicyEndorsement] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [EndorsementId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialPolicyEndorsement_CommercialPolicy_01] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[CommercialPolicy] ([PolicyId]),
    CONSTRAINT [FK_CommercialPolicyEndorsement_Endorsements_01] FOREIGN KEY ([EndorsementId]) REFERENCES [dbo].[Endorsements] ([EndorsementId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialPolicyEndorsement_01]
    ON [dbo].[CommercialPolicyEndorsement]([PolicyId] ASC)
    ON [POLICYCI];

