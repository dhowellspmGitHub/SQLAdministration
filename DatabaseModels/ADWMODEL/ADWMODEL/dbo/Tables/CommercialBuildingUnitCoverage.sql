CREATE TABLE [dbo].[CommercialBuildingUnitCoverage] (
    [PolicyId]                      INT            NOT NULL,
    [UnitNbr]                       INT            NOT NULL,
    [CoverageCd]                    CHAR (3)       NOT NULL,
    [PolicyNbr]                     VARCHAR (16)   NOT NULL,
    [CashUnitNbr]                   CHAR (3)       NULL,
    [CoverageDesc]                  VARCHAR (250)  NOT NULL,
    [CoverageLimitCd]               CHAR (3)       NULL,
    [CoveragePremiumAmt]            DECIMAL (9, 2) NULL,
    [TenantBuidlingGlassPremiumAmt] DECIMAL (9, 2) NULL,
    [PropertyOfOthersPremiumAmt]    DECIMAL (9, 2) NULL,
    [CoverageLimitAmt]              DECIMAL (9)    NULL,
    [TenantBuidlingGlassLimitAmt]   DECIMAL (9)    NULL,
    [PropertyOfOthersLimitAmt]      DECIMAL (9)    NULL,
    [CauseOfLossCd]                 CHAR (1)       NULL,
    [ValuationMethodCd]             CHAR (1)       NULL,
    [ValuationMethodDesc]           VARCHAR (255)  NULL,
    [OthersPropertyCnt]             INT            NULL,
    [CoinsTypePct]                  DECIMAL (5, 2) NULL,
    [InflationPct]                  DECIMAL (5, 2) NULL,
    [IndemnityLimitCd]              VARCHAR (10)   NULL,
    [CauseOfLossDesc]               VARCHAR (255)  NULL,
    [MechanicalBreakdownDesc]       VARCHAR (255)  NULL,
    [CreatedTmstmp]                 DATETIME       NOT NULL,
    [UserCreatedId]                 CHAR (8)       NOT NULL,
    [UpdatedTmstmp]                 DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]                 CHAR (8)       NOT NULL,
    [LastActionCd]                  CHAR (1)       NOT NULL,
    [SourceSystemCd]                CHAR (2)       NOT NULL,
    CONSTRAINT [PK_CommercialBuildingUnitCoverage] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [UnitNbr] ASC, [CoverageCd] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialBuildingUnitCoverage_CommercialBuildingUnit_01] FOREIGN KEY ([PolicyId], [UnitNbr]) REFERENCES [dbo].[CommercialBuildingUnit] ([PolicyId], [UnitNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialBuildingUnitCoverage_01]
    ON [dbo].[CommercialBuildingUnitCoverage]([PolicyId] ASC)
    ON [POLICYCI];

