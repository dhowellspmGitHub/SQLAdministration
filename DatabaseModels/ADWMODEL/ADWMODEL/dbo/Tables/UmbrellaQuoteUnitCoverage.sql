CREATE TABLE [dbo].[UmbrellaQuoteUnitCoverage] (
    [QuoteNbr]                     VARCHAR (16)   NOT NULL,
    [UnitNbr]                      INT            NOT NULL,
    [CoverageCd]                   CHAR (3)       NOT NULL,
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
    CONSTRAINT [PK_UmbrellaQuoteUnitCoverage] PRIMARY KEY CLUSTERED ([UnitNbr] ASC, [CoverageCd] ASC, [QuoteNbr] ASC),
    CONSTRAINT [FK_UmbrellaQuoteUnitCoverage_UmbrellaQuoteUnit_01] FOREIGN KEY ([UnitNbr], [QuoteNbr]) REFERENCES [dbo].[UmbrellaQuoteUnit] ([UnitNbr], [QuoteNbr])
);


GO
CREATE NONCLUSTERED INDEX [IX_UmbrellaQuoteUnitCoverage_01]
    ON [dbo].[UmbrellaQuoteUnitCoverage]([QuoteNbr] ASC)
    ON [POLICYCI];

