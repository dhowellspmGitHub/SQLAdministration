CREATE TABLE [dbo].[CommercialIMQuoteUnitEndorsement] (
    [QuoteNbr]                               VARCHAR (16)   NOT NULL,
    [EndorsementNbr]                         CHAR (10)      NOT NULL,
    [EndorsementId]                          INT            NOT NULL,
    [UnitNbr]                                INT            NOT NULL,
    [IMPartCoverageTypeCd]                   VARCHAR (50)   NOT NULL,
    [CashUnitNbr]                            CHAR (3)       NULL,
    [EndorsementPremiumAmt]                  DECIMAL (9, 2) NULL,
    [EndorsementLimitCd]                     CHAR (3)       NULL,
    [EndorsementLimitAmt]                    DECIMAL (9)    NULL,
    [InlandMarineClassCd]                    CHAR (7)       NOT NULL,
    [RiskTypeCd]                             CHAR (10)      NULL,
    [MaximumIndividualLimitAmt]              DECIMAL (9)    NULL,
    [PerEmployeeLimitAmt]                    DECIMAL (9)    NULL,
    [PerOneLossLimitAmt]                     DECIMAL (9)    NULL,
    [PerDayLimitAmt]                         DECIMAL (9)    NULL,
    [CoveredPropertiesEachOccuranceLimitAmt] DECIMAL (9)    NULL,
    [EachVehicleLimitAmt]                    DECIMAL (9)    NULL,
    [FungiIncreasedLimitAmt]                 DECIMAL (9)    NULL,
    [PropertyLimitAmt]                       DECIMAL (9)    NULL,
    [CreatedTmstmp]                          DATETIME       NOT NULL,
    [UserCreatedId]                          CHAR (8)       NOT NULL,
    [UpdatedTmstmp]                          DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]                          CHAR (8)       NOT NULL,
    [LastActionCd]                           CHAR (1)       NOT NULL,
    [SourceSystemCd]                         CHAR (2)       NOT NULL,
    CONSTRAINT [PK_CommercialIMQuoteUnitEndorsement] PRIMARY KEY CLUSTERED ([EndorsementNbr] ASC, [UnitNbr] ASC, [IMPartCoverageTypeCd] ASC, [QuoteNbr] ASC, [EndorsementId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialIMQuoteUnitEndorsement_Endorsements_01] FOREIGN KEY ([EndorsementId]) REFERENCES [dbo].[Endorsements] ([EndorsementId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialIMQuoteUnitEndorsement_01]
    ON [dbo].[CommercialIMQuoteUnitEndorsement]([QuoteNbr] ASC)
    ON [POLICYCI];

