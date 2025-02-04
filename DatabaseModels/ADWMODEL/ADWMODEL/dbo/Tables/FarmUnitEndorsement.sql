CREATE TABLE [dbo].[FarmUnitEndorsement] (
    [PolicyId]                      INT            NOT NULL,
    [UnitNbr]                       INT            NOT NULL,
    [UnitTypeCd]                    CHAR (1)       NOT NULL,
    [EndorsementNbr]                CHAR (10)      NOT NULL,
    [EndorsementId]                 INT            NULL,
    [PolicyNbr]                     VARCHAR (16)   NOT NULL,
    [SourceSystemDisplayUnitNbr]    INT            NULL,
    [CashUnitNbr]                   CHAR (3)       NULL,
    [EndorsementLimitCd]            CHAR (3)       NULL,
    [EndorsementLimitAmt]           DECIMAL (9)    NULL,
    [EndorsementPremiumAmt]         DECIMAL (9, 2) NULL,
    [EndorsementProratedPremiumAmt] DECIMAL (9, 2) NULL,
    [EndorsemenrtDeductiblePct]     DECIMAL (5, 2) NULL,
    [ChildrenCnt]                   CHAR (3)       NULL,
    [ReplacementPct]                DECIMAL (5, 2) NULL,
    [VacancyStartingDt]             DATE           NULL,
    [VacancyEndingDt]               DATE           NULL,
    [CoverageDesc]                  VARCHAR (250)  NULL,
    [ConstructionTypeDesc]          CHAR (50)      NULL,
    [DiscountPct]                   DECIMAL (5, 2) NULL,
    [FarmingOperationsDesc]         VARCHAR (255)  NULL,
    [MonthNbr]                      SMALLINT       NULL,
    [IncidentalCoverageDesc]        VARCHAR (250)  NULL,
    [IncreaseContentsCoverageInd]   CHAR (1)       NULL,
    [VaneerExclusionInd]            CHAR (1)       NULL,
    [CreatedTmstmp]                 DATETIME       NOT NULL,
    [UserCreatedId]                 CHAR (8)       NOT NULL,
    [UpdatedTmstmp]                 DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]                 CHAR (8)       NOT NULL,
    [LastActionCd]                  CHAR (1)       NOT NULL,
    [SourceSystemCd]                CHAR (2)       NOT NULL,
    CONSTRAINT [PK_FarmUnitEndorsement] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [UnitNbr] ASC, [EndorsementNbr] ASC, [UnitTypeCd] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FarmUnitEndorsement_Endorsements_01] FOREIGN KEY ([EndorsementId]) REFERENCES [dbo].[Endorsements] ([EndorsementId]),
    CONSTRAINT [FK_FarmUnitEndorsement_FarmUnit_01] FOREIGN KEY ([PolicyId], [UnitNbr], [UnitTypeCd]) REFERENCES [dbo].[FarmUnit] ([PolicyId], [UnitNbr], [UnitTypeCd])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_FarmUnitEndorsement_01]
    ON [dbo].[FarmUnitEndorsement]([PolicyId] ASC)
    ON [POLICYCI];

