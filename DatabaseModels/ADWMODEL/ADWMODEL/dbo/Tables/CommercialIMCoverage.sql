CREATE TABLE [dbo].[CommercialIMCoverage] (
    [PolicyId]                               INT             NOT NULL,
    [IMPartCoverageTypeCd]                   VARCHAR (50)    NOT NULL,
    [CoverageTypeCd]                         VARCHAR (50)    NOT NULL,
    [PolicyNbr]                              VARCHAR (16)    NOT NULL,
    [UnitNbr]                                INT             NOT NULL,
    [CashUnitNbr]                            CHAR (3)        NULL,
    [InlandMarineClassCd]                    CHAR (7)        NOT NULL,
    [CoverageLimitAmt]                       DECIMAL (9)     NULL,
    [MaximumIndividualLimitAmt]              DECIMAL (9)     NULL,
    [CoveredPropertiesEachOccurenceLimitAmt] DECIMAL (9)     NULL,
    [DeductibleAmt]                          DECIMAL (18, 2) NULL,
    [ProductsExcludedInd]                    CHAR (1)        NULL,
    [CoveragePremiumAmt]                     DECIMAL (9, 2)  NULL,
    [CreatedTmstmp]                          DATETIME        NOT NULL,
    [UserCreatedId]                          CHAR (8)        NOT NULL,
    [UpdatedTmstmp]                          DATETIME2 (7)   NOT NULL,
    [UserUpdatedId]                          CHAR (8)        NOT NULL,
    [LastActionCd]                           CHAR (1)        NOT NULL,
    [SourceSystemCd]                         CHAR (2)        NOT NULL,
    CONSTRAINT [PK_CommercialIMCoverage] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [IMPartCoverageTypeCd] ASC, [CoverageTypeCd] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialIMCoverage_CommercialIM_01] FOREIGN KEY ([PolicyId], [IMPartCoverageTypeCd]) REFERENCES [dbo].[CommercialIM] ([PolicyId], [IMPartCoverageTypeCd])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialIMCoverage_01]
    ON [dbo].[CommercialIMCoverage]([PolicyId] ASC)
    ON [POLICYCI];

