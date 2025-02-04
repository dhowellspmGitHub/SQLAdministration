CREATE TABLE [dbo].[CommercialUnitCoverage] (
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
    CONSTRAINT [PK_CommercialUnitCoverage] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [UnitNbr] ASC, [CoverageCd] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialUnitCoverage_CommercialUnit_01] FOREIGN KEY ([PolicyId], [UnitNbr]) REFERENCES [dbo].[CommercialUnit] ([PolicyId], [UnitNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialUnitCoverage_01]
    ON [dbo].[CommercialUnitCoverage]([PolicyId] ASC)
    ON [POLICYCI];

