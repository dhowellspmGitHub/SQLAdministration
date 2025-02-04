CREATE TABLE [dbo].[UmbrellaUnitCoverage] (
    [UnitNbr]                      INT            NOT NULL,
    [CoverageCd]                   CHAR (3)       NOT NULL,
    [PolicyId]                     INT            NOT NULL,
    [PolicyNbr]                    VARCHAR (16)   NOT NULL,
    [CoverageDesc]                 VARCHAR (250)  NOT NULL,
    [CoverageLimitCd]              CHAR (3)       NULL,
    [CoverageLimitCodeDesc]        VARCHAR (20)   NULL,
    [CoverageLimitAmt]             DECIMAL (9)    NULL,
    [CoveragePremiumAmt]           DECIMAL (9, 2) NULL,
    [CoverageDeductibleTypeCd]     CHAR (3)       NULL,
    [CoverageDeductibleCd]         CHAR (3)       NULL,
    [CoverageDeductibleAmt]        DECIMAL (5)    NULL,
    [CoverageDedWindHailAmt]       DECIMAL (9)    NULL,
    [SourceSystemCoverageCd]       VARCHAR (100)  NULL,
    [EachIncidentCoverageLimitAmt] DECIMAL (9)    NULL,
    [PerPersonCoverageLimitAmt]    DECIMAL (9)    NULL,
    [ManWorkDaysNbr]               INT            NULL,
    [ProfessionalLiabilityDesc]    VARCHAR (255)  NULL,
    [CSLInd]                       CHAR (1)       NULL,
    [UpdatedTmstmp]                DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]                CHAR (8)       NOT NULL,
    [LastActionCd]                 CHAR (1)       NOT NULL,
    [SourceSystemCd]               CHAR (2)       NOT NULL,
    CONSTRAINT [PK_UmbrellaUnitCoverage] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [UnitNbr] ASC, [CoverageCd] ASC) ON [POLICYCD],
    CONSTRAINT [FK_UmbrellaUnitCoverage_UmbrellaUnit_01] FOREIGN KEY ([PolicyId], [UnitNbr]) REFERENCES [dbo].[UmbrellaUnit] ([PolicyId], [UnitNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_UmbrellaUnitCoverage_01]
    ON [dbo].[UmbrellaUnitCoverage]([PolicyId] ASC)
    ON [POLICYCI];

