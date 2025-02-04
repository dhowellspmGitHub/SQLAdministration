CREATE TABLE [dbo].[HomeUnitEndorsement] (
    [EndorsementId]                 INT            NOT NULL,
    [PolicyId]                      INT            NOT NULL,
    [UnitNbr]                       INT            NOT NULL,
    [PolicyNbr]                     VARCHAR (16)   NOT NULL,
    [EndorsementNbr]                CHAR (10)      NOT NULL,
    [EndorsementLimitAmt]           DECIMAL (9)    NULL,
    [EndorsementLimitCd]            CHAR (3)       NULL,
    [EndorsementPremiumAmt]         DECIMAL (9, 2) NULL,
    [EndorsementProratedPremiumAmt] DECIMAL (9, 2) NULL,
    [VaneerExclusionInd]            CHAR (1)       NULL,
    [ComputerCnt]                   INT            NULL,
    [EarthQuakeDeductiblePct]       DECIMAL (9, 2) NULL,
    [LiveStockRangeNbr]             CHAR (10)      NULL,
    [LimitIncreaseInPct]            DECIMAL (9, 2) NULL,
    [FullReplacementPct]            DECIMAL (9, 2) NULL,
    [UpdatedTmstmp]                 DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]                 CHAR (8)       NOT NULL,
    [LastActionCd]                  CHAR (1)       NOT NULL,
    [SourceSystemCd]                CHAR (2)       NOT NULL,
    CONSTRAINT [PK_HomeUnitEndorsement] PRIMARY KEY CLUSTERED ([EndorsementId] ASC, [PolicyId] ASC, [UnitNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_HomeUnitEndorsement_Endorsements_01] FOREIGN KEY ([EndorsementId]) REFERENCES [dbo].[Endorsements] ([EndorsementId]),
    CONSTRAINT [FK_HomeUnitEndorsement_HomeUnit_01] FOREIGN KEY ([PolicyId], [UnitNbr]) REFERENCES [dbo].[HomeUnit] ([PolicyId], [UnitNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_HomeUnitEndorsement_01]
    ON [dbo].[HomeUnitEndorsement]([PolicyId] ASC, [UnitNbr] ASC)
    ON [POLICYCI];


GO
CREATE NONCLUSTERED INDEX [IX_HomeUnitEndorsement_02]
    ON [dbo].[HomeUnitEndorsement]([PolicyId] ASC)
    ON [POLICYCI];

