CREATE TABLE [dbo].[PolicyCoverage] (
    [PolicyId]                INT            NOT NULL,
    [CoverageCd]              CHAR (3)       NOT NULL,
    [PolicyNbr]               VARCHAR (16)   NOT NULL,
    [LineofBusinessCd]        CHAR (2)       NOT NULL,
    [SublineBusinessTypeCd]   CHAR (1)       NOT NULL,
    [CoverageDesc]            VARCHAR (250)  NULL,
    [CoverageTypeCd]          CHAR (1)       NULL,
    [CoverageLimitCd]         CHAR (3)       NULL,
    [CoverageLimitCodeDesc]   VARCHAR (20)   NULL,
    [CoverageLimitAmt]        DECIMAL (9)    NULL,
    [CoverageDeductibleCd]    CHAR (3)       NULL,
    [CoverageDeductibleAmt]   DECIMAL (5)    NULL,
    [TotalCoveragePremiumAmt] DECIMAL (9, 2) NULL,
    [UpdatedTmstmp]           DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]           CHAR (8)       NOT NULL,
    [LastActionCd]            CHAR (1)       NOT NULL,
    [SourceSystemCd]          CHAR (2)       NOT NULL,
    CONSTRAINT [PK_PolicyCoverage] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [CoverageCd] ASC) ON [POLICYCD],
    CONSTRAINT [FK_PolicyCoverage_Policy_01] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[Policy] ([PolicyId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_PolicyCoverage_02]
    ON [dbo].[PolicyCoverage]([PolicyId] ASC, [PolicyNbr] ASC)
    ON [POLICYCI];


GO
CREATE NONCLUSTERED INDEX [IX_PolicyCoverage_01]
    ON [dbo].[PolicyCoverage]([PolicyNbr] ASC)
    ON [POLICYCI];


GO
CREATE NONCLUSTERED INDEX [IX_PolicyCoverage_03]
    ON [dbo].[PolicyCoverage]([PolicyId] ASC)
    ON [POLICYCI];

