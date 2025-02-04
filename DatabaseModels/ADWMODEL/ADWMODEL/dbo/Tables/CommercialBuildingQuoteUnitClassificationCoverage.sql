CREATE TABLE [dbo].[CommercialBuildingQuoteUnitClassificationCoverage] (
    [UnitNbr]            INT            NOT NULL,
    [CoverageCd]         CHAR (3)       NOT NULL,
    [ClassificationNbr]  INT            NOT NULL,
    [QuoteNbr]           VARCHAR (16)   NOT NULL,
    [CoverageLimitAmt]   DECIMAL (9)    NULL,
    [CoveragePremiumAmt] DECIMAL (9, 2) NULL,
    [CoverageDesc]       VARCHAR (250)  NOT NULL,
    [CreatedTmstmp]      DATETIME       NOT NULL,
    [UserCreatedId]      CHAR (8)       NOT NULL,
    [UpdatedTmstmp]      DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]      CHAR (8)       NOT NULL,
    [LastActionCd]       CHAR (1)       NOT NULL,
    [SourceSystemCd]     CHAR (2)       NOT NULL,
    CONSTRAINT [PK_CommercialBuildingQuoteUnitClassificationCoverage] PRIMARY KEY CLUSTERED ([CoverageCd] ASC, [UnitNbr] ASC, [ClassificationNbr] ASC, [QuoteNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialBuildingQuoteUnitClassificationCoverage_CommercialBuildingQuoteUnitClassification_01] FOREIGN KEY ([ClassificationNbr], [UnitNbr], [QuoteNbr]) REFERENCES [dbo].[CommercialBuildingQuoteUnitClassification] ([ClassificationNbr], [UnitNbr], [QuoteNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialBuildingQuoteUnitClassificationCoverage_01]
    ON [dbo].[CommercialBuildingQuoteUnitClassificationCoverage]([QuoteNbr] ASC)
    ON [POLICYCI];

