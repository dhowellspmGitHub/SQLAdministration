CREATE TABLE [dbo].[MobileHomeUnitEndorsement] (
    [EndorsementId]                  INT            NOT NULL,
    [PolicyId]                       INT            NOT NULL,
    [UnitNbr]                        INT            NOT NULL,
    [PolicyNbr]                      VARCHAR (16)   NOT NULL,
    [EndorsementNbr]                 CHAR (10)      NOT NULL,
    [EndorsementLimitAmt]            DECIMAL (9)    NULL,
    [EndorsementLimitCd]             CHAR (3)       NULL,
    [EndorsementPremiumAmt]          DECIMAL (9, 2) NULL,
    [EndorsementProratedPremiumAmt]  DECIMAL (9, 2) NULL,
    [AppliedDeductiblePercentageInd] CHAR (1)       NULL,
    [OverCoachAnchoringInd]          CHAR (1)       NULL,
    [EarthQuakeDeductiblePct]        DECIMAL (9, 2) NULL,
    [UpdatedTmstmp]                  DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]                  CHAR (8)       NOT NULL,
    [LastActionCd]                   CHAR (1)       NOT NULL,
    [SourceSystemCd]                 CHAR (2)       NOT NULL,
    CONSTRAINT [PK_MobileHomeUnitEndorsement] PRIMARY KEY CLUSTERED ([EndorsementId] ASC, [PolicyId] ASC, [UnitNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_MobileHomeUnitEndorsement_Endorsements_01] FOREIGN KEY ([EndorsementId]) REFERENCES [dbo].[Endorsements] ([EndorsementId]),
    CONSTRAINT [FK_MobileHomeUnitEndorsement_MobileHomeUnit_01] FOREIGN KEY ([PolicyId], [UnitNbr]) REFERENCES [dbo].[MobileHomeUnit] ([PolicyId], [UnitNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_MobileHomeUnitEndorsement_02]
    ON [dbo].[MobileHomeUnitEndorsement]([PolicyId] ASC)
    ON [POLICYCI];


GO
CREATE NONCLUSTERED INDEX [IX_MobileHomeUnitEndorsement_01]
    ON [dbo].[MobileHomeUnitEndorsement]([PolicyId] ASC, [UnitNbr] ASC)
    ON [POLICYCI];

