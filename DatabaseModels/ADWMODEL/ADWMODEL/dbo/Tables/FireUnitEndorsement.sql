CREATE TABLE [dbo].[FireUnitEndorsement] (
    [PolicyId]                      INT            NOT NULL,
    [EndorsementId]                 INT            NOT NULL,
    [UnitNbr]                       INT            NOT NULL,
    [PolicyNbr]                     VARCHAR (16)   NOT NULL,
    [EndorsementNbr]                CHAR (10)      NOT NULL,
    [EndorsementLimitAmt]           DECIMAL (9)    NULL,
    [EndorsementPremiumAmt]         DECIMAL (9, 2) NULL,
    [EndorsementProratedPremiumAmt] DECIMAL (9, 2) NULL,
    [VaneerExclusionInd]            CHAR (1)       NULL,
    [EarthQuakeDeductiblePct]       DECIMAL (9, 2) NULL,
    [LimitIncreaseInPct]            DECIMAL (9, 2) NULL,
    [OccupancyDesc]                 VARCHAR (30)   NULL,
    [CoverageOptionsDesc]           VARCHAR (255)  NULL,
    [EndorsementLimitCd]            CHAR (3)       NULL,
    [UpdatedTmstmp]                 DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]                 CHAR (8)       NOT NULL,
    [LastActionCd]                  CHAR (1)       NOT NULL,
    [SourceSystemCd]                CHAR (2)       NOT NULL,
    CONSTRAINT [PK_FireUnitEndorsement] PRIMARY KEY CLUSTERED ([UnitNbr] ASC, [PolicyId] ASC, [EndorsementId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FireUnitEndorsement_Endorsements_01] FOREIGN KEY ([EndorsementId]) REFERENCES [dbo].[Endorsements] ([EndorsementId]),
    CONSTRAINT [FK_FireUnitEndorsement_FireUnit_01] FOREIGN KEY ([PolicyId], [UnitNbr]) REFERENCES [dbo].[FireUnit] ([PolicyId], [UnitNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_FireUnitEndorsement_01]
    ON [dbo].[FireUnitEndorsement]([PolicyId] ASC)
    ON [POLICYCI];

