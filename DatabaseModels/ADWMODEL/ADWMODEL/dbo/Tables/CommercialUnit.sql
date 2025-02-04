CREATE TABLE [dbo].[CommercialUnit] (
    [PolicyId]                 INT           NOT NULL,
    [UnitNbr]                  INT           NOT NULL,
    [PolicyNbr]                VARCHAR (16)  NOT NULL,
    [ItemNbr]                  CHAR (3)      NOT NULL,
    [RateClassCd]              CHAR (5)      NULL,
    [LiablityClassCd]          CHAR (5)      NULL,
    [ExposureBaseAmt]          INT           NULL,
    [ConstructionTypeCd]       CHAR (1)      NULL,
    [ConstructionYearDt]       CHAR (4)      NULL,
    [SurchargeExemptStatusCd]  CHAR (1)      NULL,
    [ProtectionClassCd]        CHAR (2)      NULL,
    [CrimeCoverageOptionCd]    CHAR (1)      NULL,
    [EarthquakeCoverageCd]     CHAR (1)      NULL,
    [EarthquakeConstructionCd] CHAR (1)      NULL,
    [MineSubsidenceInd]        CHAR (1)      NULL,
    [ProductsCompletedInd]     CHAR (1)      NULL,
    [MechanicalBreakdownInd]   CHAR (1)      NULL,
    [MinimumPremiumInd]        CHAR (1)      NULL,
    [CoInsurancePercentageCd]  CHAR (1)      NULL,
    [LocationCountyNbr]        CHAR (3)      NULL,
    [TerritoryCd]              CHAR (1)      NULL,
    [ProgramCd]                CHAR (1)      NULL,
    [OccupancyTypeCd]          CHAR (1)      NULL,
    [InlandMarineClassCd]      CHAR (4)      NULL,
    [InlandMarineSubClassCd]   CHAR (1)      NULL,
    [UnitMiscellaneousDesc]    VARCHAR (250) NULL,
    [ItemMiscellaneousDesc]    VARCHAR (250) NULL,
    [BusinessLimitAmt]         INT           NULL,
    [UpdatedTmstmp]            DATETIME2 (7) NOT NULL,
    [UserUpdatedId]            CHAR (8)      NOT NULL,
    [LastActionCd]             CHAR (1)      NOT NULL,
    [SourceSystemCd]           CHAR (2)      NOT NULL,
    CONSTRAINT [PK_CommercialUnit] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [UnitNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialUnit_CommercialPolicy_01] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[CommercialPolicy] ([PolicyId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialUnit_01]
    ON [dbo].[CommercialUnit]([PolicyId] ASC)
    ON [POLICYCI];

