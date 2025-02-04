CREATE TABLE [dbo].[CommercialBuildingQuoteUnitEndorsementDetail] (
    [CommercialBuildingQuoteUnitEndorsementDetailId] INT            NOT NULL,
    [QuoteNbr]                                       VARCHAR (16)   NOT NULL,
    [UnitNbr]                                        INT            NOT NULL,
    [EndorsementNbr]                                 CHAR (10)      NOT NULL,
    [EndorsementId]                                  INT            NOT NULL,
    [LocationID]                                     BIGINT         NULL,
    [CashUnitNbr]                                    CHAR (3)       NULL,
    [ItemNbr]                                        CHAR (3)       NOT NULL,
    [EndorsementLimitAmt]                            DECIMAL (9)    NOT NULL,
    [EndorsementPremiumAmt]                          DECIMAL (9, 2) NOT NULL,
    [CoverageStartDate]                              DATE           NULL,
    [CoverageEndDt]                                  DATE           NULL,
    [CoveredPropertyDesc]                            VARCHAR (255)  NULL,
    [UtilitiesDesc]                                  VARCHAR (255)  NULL,
    [UtilityTypeDesc]                                VARCHAR (255)  NULL,
    [CreatedTmstmp]                                  DATETIME       NOT NULL,
    [UserCreatedId]                                  CHAR (8)       NOT NULL,
    [UpdatedTmstmp]                                  DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]                                  CHAR (8)       NOT NULL,
    [LastActionCd]                                   CHAR (1)       NOT NULL,
    [SourceSystemCd]                                 CHAR (2)       NOT NULL,
    CONSTRAINT [PK_CommercialBuildingQuoteUnitEndorsementDetail] PRIMARY KEY CLUSTERED ([CommercialBuildingQuoteUnitEndorsementDetailId] ASC, [EndorsementNbr] ASC, [UnitNbr] ASC, [EndorsementId] ASC, [QuoteNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialBuildingQuoteUnitEndorsementDetail_CommercialBuildingQuoteUnitEndorsement_01] FOREIGN KEY ([EndorsementNbr], [UnitNbr], [QuoteNbr], [EndorsementId]) REFERENCES [dbo].[CommercialBuildingQuoteUnitEndorsement] ([EndorsementNbr], [UnitNbr], [QuoteNbr], [EndorsementId]),
    CONSTRAINT [FK_CommercialBuildingQuoteUnitEndorsementDetail_Location_01] FOREIGN KEY ([LocationID]) REFERENCES [dbo].[Location] ([LocationID])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialBuildingQuoteUnitEndorsementDetail_01]
    ON [dbo].[CommercialBuildingQuoteUnitEndorsementDetail]([QuoteNbr] ASC)
    ON [POLICYCI];

