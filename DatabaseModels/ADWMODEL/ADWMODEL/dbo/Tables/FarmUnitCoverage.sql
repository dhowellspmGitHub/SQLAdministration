CREATE TABLE [dbo].[FarmUnitCoverage] (
    [PolicyId]                   INT            NOT NULL,
    [CoverageCd]                 CHAR (3)       NOT NULL,
    [UnitNbr]                    INT            NOT NULL,
    [UnitTypeCd]                 CHAR (1)       NOT NULL,
    [PolicyNbr]                  VARCHAR (16)   NOT NULL,
    [SourceSystemDisplayUnitNbr] INT            NULL,
    [CashUnitNbr]                CHAR (3)       NULL,
    [CoverageDesc]               VARCHAR (250)  NULL,
    [CoverageLimitCd]            CHAR (3)       NULL,
    [CoverageLimitCodeDesc]      VARCHAR (20)   NULL,
    [CoverageLimitAmt]           DECIMAL (9)    NULL,
    [CoveragePremiumAmt]         DECIMAL (9, 2) NULL,
    [MainDwellingPct]            DECIMAL (5, 2) NULL,
    [ValuationMethodCd]          CHAR (1)       NULL,
    [SourceSystemCoverageCd]     VARCHAR (100)  NULL,
    [CreatedTmstmp]              DATETIME       NOT NULL,
    [UserCreatedId]              CHAR (8)       NOT NULL,
    [UpdatedTmstmp]              DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]              CHAR (8)       NOT NULL,
    [LastActionCd]               CHAR (1)       NOT NULL,
    [SourceSystemCd]             CHAR (2)       NOT NULL,
    CONSTRAINT [PK_FarmUnitCoverage] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [CoverageCd] ASC, [UnitNbr] ASC, [UnitTypeCd] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FarmUnitCoverage_FarmUnit_01] FOREIGN KEY ([PolicyId], [UnitNbr], [UnitTypeCd]) REFERENCES [dbo].[FarmUnit] ([PolicyId], [UnitNbr], [UnitTypeCd])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_FarmUnitCoverage_01]
    ON [dbo].[FarmUnitCoverage]([PolicyId] ASC)
    ON [POLICYCI];

