CREATE TABLE [dbo].[CommercialBuildingUnitClassificationCoverage] (
    [PolicyId]           INT            NOT NULL,
    [UnitNbr]            INT            NOT NULL,
    [CoverageCd]         CHAR (3)       NOT NULL,
    [ClassificationNbr]  INT            NOT NULL,
    [PolicyNbr]          VARCHAR (16)   NOT NULL,
    [CoverageLimitAmt]   DECIMAL (9)    NULL,
    [CoveragePremiumAmt] DECIMAL (9, 2) NULL,
    [CoverageDesc]       VARCHAR (250)  NOT NULL,
    [CreatedTmstmp]      DATETIME       NOT NULL,
    [UserCreatedId]      CHAR (8)       NOT NULL,
    [UpdatedTmstmp]      DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]      CHAR (8)       NOT NULL,
    [LastActionCd]       CHAR (1)       NOT NULL,
    [SourceSystemCd]     CHAR (2)       NOT NULL,
    CONSTRAINT [PK_CommercialBuildingUnitClassificationCoverage] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [UnitNbr] ASC, [ClassificationNbr] ASC, [CoverageCd] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialBuildingUnitClassificationCoverage_CommercialBuildingUnitClassification_01] FOREIGN KEY ([PolicyId], [UnitNbr], [ClassificationNbr]) REFERENCES [dbo].[CommercialBuildingUnitClassification] ([PolicyId], [UnitNbr], [ClassificationNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialBuildingUnitClassificationCoverage_01]
    ON [dbo].[CommercialBuildingUnitClassificationCoverage]([PolicyId] ASC)
    ON [POLICYCI];

