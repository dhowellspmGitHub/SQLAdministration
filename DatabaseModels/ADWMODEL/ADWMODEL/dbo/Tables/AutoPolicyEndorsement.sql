CREATE TABLE [dbo].[AutoPolicyEndorsement] (
    [PolicyId]                       INT            NOT NULL,
    [EndorsementNbr]                 CHAR (10)      NOT NULL,
    [PolicyNbr]                      VARCHAR (16)   NOT NULL,
    [SublineBusinessTypeCd]          CHAR (1)       NOT NULL,
    [EndorsementDesc]                VARCHAR (100)  NULL,
    [EndorsementEditionYearDt]       CHAR (4)       NULL,
    [EndorsementEffectiveDt]         DATE           NULL,
    [EndorsementLimitCd]             CHAR (3)       NULL,
    [EndorsementLimitAmt]            DECIMAL (9)    NULL,
    [EndorsementPremiumAmt]          DECIMAL (9, 2) NULL,
    [EndorsementDeductibleCd]        CHAR (3)       NULL,
    [EndorsementMailFlagInd]         CHAR (1)       NULL,
    [EndorsementAppliedToCoverageCd] CHAR (3)       NULL,
    [MinimumPremInd]                 BIT            NULL,
    [UpdatedTmstmp]                  DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]                  CHAR (8)       NOT NULL,
    [LastActionCd]                   CHAR (1)       NOT NULL,
    [SourceSystemCd]                 CHAR (2)       NOT NULL,
    CONSTRAINT [PK_AutoPolicyEndorsement] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [EndorsementNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AutoPolicyEndorsement_AutoPolicy_01] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[AutoPolicy] ([PolicyId])
) ON [POLICYCD];

