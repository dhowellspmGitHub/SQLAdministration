CREATE TABLE [dbo].[FireUnitCoverage] (
    [PolicyId]                 INT            NOT NULL,
    [UnitNbr]                  INT            NOT NULL,
    [CoverageCd]               CHAR (3)       NOT NULL,
    [PolicyNbr]                VARCHAR (16)   NOT NULL,
    [CoverageDesc]             VARCHAR (250)  NOT NULL,
    [CoverageLimitCd]          CHAR (3)       NULL,
    [CoverageLimitCodeDesc]    VARCHAR (20)   NULL,
    [CoverageLimitAmt]         DECIMAL (9)    NULL,
    [CoveragePremiumAmt]       DECIMAL (9, 2) NULL,
    [CoverageDeductibleTypeCd] CHAR (3)       NULL,
    [CoverageDeductibleCd]     CHAR (3)       NULL,
    [CoverageDeductibleAmt]    DECIMAL (5)    NULL,
    [CoverageDedWindHailAmt]   DECIMAL (9)    NULL,
    [SourceSystemCoverageCd]   VARCHAR (100)  NULL,
    [UpdatedTmstmp]            DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]            CHAR (8)       NOT NULL,
    [LastActionCd]             CHAR (1)       NOT NULL,
    [SourceSystemCd]           CHAR (2)       NOT NULL,
    CONSTRAINT [PK_FireUnitCoverage] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [UnitNbr] ASC, [CoverageCd] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FireUnitCoverage_FireUnit_01] FOREIGN KEY ([PolicyId], [UnitNbr]) REFERENCES [dbo].[FireUnit] ([PolicyId], [UnitNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_FireUnitCoverage_01]
    ON [dbo].[FireUnitCoverage]([PolicyId] ASC)
    ON [POLICYCI];

