CREATE TABLE [dbo].[FireUnitCoverageItem] (
    [PolicyId]           INT            NOT NULL,
    [UnitNbr]            INT            NOT NULL,
    [CoverageCd]         CHAR (3)       NOT NULL,
    [CoverageItemCd]     CHAR (3)       NOT NULL,
    [PolicyNbr]          VARCHAR (16)   NOT NULL,
    [CoverageLimitAmt]   DECIMAL (9)    NULL,
    [CoveragePremiumAmt] DECIMAL (9, 2) NULL,
    [UserUpdatedId]      CHAR (8)       NOT NULL,
    [UpdatedTmstmp]      DATETIME2 (7)  NOT NULL,
    [UserCreatedId]      CHAR (8)       NOT NULL,
    [CreatedTmstmp]      DATETIME       NOT NULL,
    [LastActionCd]       CHAR (1)       NOT NULL,
    [SourceSystemCd]     CHAR (2)       NOT NULL,
    CONSTRAINT [PK_FireUnitCoverageItem] PRIMARY KEY NONCLUSTERED ([UnitNbr] ASC, [CoverageCd] ASC, [PolicyId] ASC, [CoverageItemCd] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FireUnitCoverageItem_FireUnitCoverage_01] FOREIGN KEY ([PolicyId], [UnitNbr], [CoverageCd]) REFERENCES [dbo].[FireUnitCoverage] ([PolicyId], [UnitNbr], [CoverageCd])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_FireUnitCoverageItem_01]
    ON [dbo].[FireUnitCoverageItem]([PolicyId] ASC)
    ON [POLICYCI];

