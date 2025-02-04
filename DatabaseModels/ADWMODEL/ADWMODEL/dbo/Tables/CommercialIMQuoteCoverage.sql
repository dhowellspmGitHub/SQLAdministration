CREATE TABLE [dbo].[CommercialIMQuoteCoverage] (
    [QuoteNbr]                               VARCHAR (16)    NOT NULL,
    [IMPartCoverageTypeCd]                   VARCHAR (50)    NOT NULL,
    [CoverageTypeCd]                         VARCHAR (50)    NOT NULL,
    [UnitNbr]                                INT             NOT NULL,
    [CashUnitNbr]                            CHAR (3)        NULL,
    [InlandMarineClassCd]                    CHAR (7)        NOT NULL,
    [CoverageLimitAmt]                       DECIMAL (9)     NULL,
    [CoveragePremiumAmt]                     DECIMAL (9, 2)  NULL,
    [MaximumIndividualLimitAmt]              DECIMAL (9)     NULL,
    [CoveredPropertiesEachOccurenceLimitAmt] DECIMAL (9)     NULL,
    [DeductibleAmt]                          DECIMAL (18, 2) NULL,
    [CreatedTmstmp]                          DATETIME        NOT NULL,
    [UserCreatedId]                          CHAR (8)        NOT NULL,
    [UpdatedTmstmp]                          DATETIME2 (7)   NOT NULL,
    [UserUpdatedId]                          CHAR (8)        NOT NULL,
    [LastActionCd]                           CHAR (1)        NOT NULL,
    [SourceSystemCd]                         CHAR (2)        NOT NULL,
    CONSTRAINT [PK_CommercialIMQuoteCoverage] PRIMARY KEY CLUSTERED ([IMPartCoverageTypeCd] ASC, [QuoteNbr] ASC, [CoverageTypeCd] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialIMQuoteCoverage_CommercialIMQuote_01] FOREIGN KEY ([IMPartCoverageTypeCd], [QuoteNbr]) REFERENCES [dbo].[CommercialIMQuote] ([IMPartCoverageTypeCd], [QuoteNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialIMQuoteCoverage_01]
    ON [dbo].[CommercialIMQuoteCoverage]([QuoteNbr] ASC)
    ON [POLICYCI];

